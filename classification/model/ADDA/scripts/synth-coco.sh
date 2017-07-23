#!/bin/bash

# abort entire script on error
set -e
# print before execution
set -o xtrace

NAME_PREFIX=

DATA_ROOT=/home/ubuntu/data/visda_copy

TRAIN_DATA=vda2017s
TEST_DATA=vda2017coco
TRAIN_SPLIT=train
TEST_SPLIT=train

BASE_MODEL_NAME=lenet

SOURCE_MODEL_NAME=$BASE_MODEL_NAME\_$TRAIN_DATA\_$TRAIN_SPLIT\_$NAME_PREFIX
ADAPTED_MODEL_NAME=adda_$BASE_MODEL_NAME\_$TRAIN_DATA\_$TRAIN_SPLIT\_$TEST_DATA\_$TEST_SPLIT\_$NAME_PREFIX

echo train $SOURCE_MODEL_NAME

export PYTHONPATH="$PWD:$PYTHONPATH"

#DEBUG_CALL_ARGS=' -m pdb -c c '
DEBUG_CALL_ARGS=''

# train base model on vda2017s (train)
python3 $DEBUG_CALL_ARGS \
        tools/train.py $DATA_ROOT $TRAIN_DATA $TRAIN_SPLIT $BASE_MODEL_NAME $SOURCE_MODEL_NAME \
        --iterations 10000 \
        --batch_size 50 \
        --display 10 \
        --lr 0.001 \
        --snapshot 5000 \
        --solver adam

# run adda vda2017s->vda2017coco (test)
python3 $DEBUG_CALL_ARGS \
       tools/train_adda.py $DATA_ROOT $TRAIN_DATA\:$TRAIN_SPLIT $TEST_DATA\:$TEST_SPLIT \
       $BASE_MODEL_NAME $ADAPTED_MODEL_NAME \
       --iterations 10000 \
       --batch_size 50 \
       --display 10 \
       --lr 0.0002 \
       --snapshot 5000 \
       --weights snapshot/$SOURCE_MODEL_NAME \
       --adversary_relu \
       --solver adam

# evaluate trained models and write predictions into predictions/$model.txt
echo 'Source only baseline:'
mkdir -p predictions
python3 tools/eval_classification.py $DATA_ROOT $TEST_DATA $TEST_SPLIT $BASE_MODEL_NAME \
            snapshot/$SOURCE_MODEL_NAME predictions/$SOURCE_MODEL_NAME.txt

echo 'ADDA':
python3 tools/eval_classification.py $DATA_ROOT $TEST_DATA $TEST_SPLIT $BASE_MODEL_NAME \
            snapshot/$ADAPTED_MODEL_NAME predictions/$ADAPTED_MODEL_NAME.txt