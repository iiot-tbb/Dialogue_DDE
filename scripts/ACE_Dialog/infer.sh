#!/bin/bash
set -ux

SAVE_DIR=outputs/DDE.infer
VOCAB_PATH=model/Bert/vocab.txt
DATA_DIR=data/DDE_Dialog
INIT_CHECKPOINT=outputs/DDE_Dialog/best.model
DATA_TYPE=multi_knowledge

# CUDA environment settings.
export CUDA_VISIBLE_DEVICES=0
LD_LIBRARY_PATH=~/miniconda3/envs/plato/lib/
export LD_LIBRARY_PATH

# Paddle environment settings.
export FLAGS_fraction_of_gpu_memory_to_use=0.2
export FLAGS_eager_delete_scope=True
export FLAGS_eager_delete_tensor_gb=0.0

python -u \
    ./preprocess.py \ #前处理文件，把原始的对话文件转换成对应的encoding文件
    --vocab_path $VOCAB_PATH \
    --data_dir $DATA_DIR \
    --data_type $DATA_TYPE

python -u \
    ./run.py \
    --do_infer true \
    --vocab_path $VOCAB_PATH \
    --data_dir $DATA_DIR \
    --data_type $DATA_TYPE \
    --batch_size 1 \
    --num_type_embeddings 3 \
    --use_discriminator true \
    --init_checkpoint $INIT_CHECKPOINT \
    --save_dir $SAVE_DIR
