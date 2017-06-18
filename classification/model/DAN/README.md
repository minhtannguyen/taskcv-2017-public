## Introduction
Deep adaptation network is proposed by [Learning Transferable Features with Deep Adaptation Networks](https://arxiv.org/pdf/1502.02791.pdf). Please cite the original paper if you use any material (code, algorithm, etc) provided by the authors. For this baseline model, we only provide code for Caffe version.

## Run the baseline

1. Get the modified Caffe code by cloning the repository: `git clone https://github.com/thuml/transfer-caffe.git`. Let's call the palce where you installed caffe `$CAFFE_ROOT`.

2. **Install DAN** (See [Caffe installation Instructions](http://caffe.berkeleyvision.org/installation.html) for help).

3. **Data Preparation**: To run the model, you should prepare `train.txt`, `test.txt`. The file `../../data/train/image_list.txt` and `../../data/validation/image_list.txt` can be used to generate the files by replacing the relative path to absolute path. **Note**: `train.txt` and `test.txt` should be placed to the same directory with `dan_train_val_visda17.prototxt`

4. **Training Model**. We provide `dan_train_val_visda17.prototxt` as the network architecture, you can visualize it with [ethereon](http://ethereon.github.io/netscope/quickstart.html). The [bvlc\_reference\_caffenet.caffemodel](http://dl.caffe.berkeleyvision.org/bvlc_reference_caffenet.caffemodel) is used as the pre-trained model. If the `train.prototxt`, `test.prototxt` and pre-trained caffemodel are prepared, the model can be run with the following command:

```
"$CAFFE_ROOT/build/tools/caffe train -solver solver.prototxt -weights /path/to/your/pre-trained/model/bvlc_reference_caffenet.caffemodel -gpu GPU_ID 2>&1 | tee office_DAN.txt"
```

5. **Testing**. Modify the `train_file_path`,`deploy_file_path` and `weight_path` in `../../exp_pred.m`, and run `>> exp_pred()`. The function will generate a text file containing all the  in `../../result/` with the most recent timestampe.

6. **Calculate Mean Accuracy**. Run `>> exp_eval()`.

## Baseline Result
 aeroplane|	bicycle|	bus|	car|	horse|	knife|	motorcycle|	person|	pottedplant|	skateboard|	train|	truck|	mean accuracy
  :---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:
 
---------------
In mmd-layer, parameter `loss_weight` can be tuned to give mmd loss different weights.
