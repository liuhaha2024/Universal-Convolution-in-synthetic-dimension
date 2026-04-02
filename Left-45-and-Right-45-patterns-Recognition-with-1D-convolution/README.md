# Left-45-and-Right-45-patterns-Recognition-with-1D-convolution
Left-45 and Right-45 patterns Recognition with 1D convolution
This code is used for calculating the results in Figures S3e–S3f,  which compares the performance of the task on recognizing Left-45 and Right-45 patterns, with numerically symmetric and asymmetric convolution kernels.

task: Left-45 and Right-45 patterns Recognition with 1D convolution
device: cuda
conv_mode: symmetric & asymmetric
batch_size: 512
initial_learning_rate: 0.001
epoch_num: 50
image_size: (30, 30)
num_classes: 2
train_samples_per_class: 30000
test_samples_per_class: 6000
noise_sigma: 0.45
architecture: Flatten(30x30->900)->Conv1(8,1x3)->GELU->Conv2(1,1x3)->GELU->Flatten(900)->Linear(2)

As the random seed was not strictly fixed, the reproduced accuracies may not exactly match those reported in the paper. However, the asymmetric kernels consistently outperform the symmetric ones across multiple runs, suggesting that the main conclusion is robust despite stochastic variation.
