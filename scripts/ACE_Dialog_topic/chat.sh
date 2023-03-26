#!/bin/bash
set -ux

SAVE_DIR=outputs/DDE.infer
VOCAB_PATH=model/Bert/vocab.txt
DATA_DIR=data/DDE_Dialog
#INIT_CHECKPOINT=outputs/DDE_Dialog/best.model
#INIT_CHECKPOINT=outputs/ACE_Dialog_pointer_context_transfer2_new/best.model
#INIT_CHECKPOINT=outputs/ACE_Dialog_pointer2_context/best.model
DATA_TYPE=multi_knowledge
LD_LIBRARY_PATH=~/miniconda3/envs/plato/lib/
export LD_LIBRARY_PATH
#echo $LD_LIBRARY_PATH  ~/miniconda3/pkgs/cudatoolkit-10.1.243-h6bb024c_0/lib
#echo $LD_LIBRARY_PATH /usr/local/cuda-9.1/lib64/
#/libcublas.so
# CUDA environment settings.
export CUDA_VISIBLE_DEVICES=0,1,2,3
./miniconda3/envs/plato/lib/libcublas.so
# Paddle environment settings.
export FLAGS_fraction_of_gpu_memory_to_use=0.1
export FLAGS_eager_delete_scope=True
export FLAGS_eager_delete_tensor_gb=0.0

python -u \
    ./preprocess.py \ #前处理文件，把原始的对话文件转换成对应的encoding文件
    --vocab_path $VOCAB_PATH \
    --data_dir $DATA_DIR \
    --data_type $DATA_TYPE
    
#python -u \
#    ./chat.py
    #  --do_infer true \
    #  --vocab_path $VOCAB_PATH \
    #  --data_dir $DATA_DIR \
    #  --data_type $DATA_TYPE \
    #  --batch_size 1 \
    #  --num_type_embeddings 3 \
    #  --use_discriminator false \
    #  --init_checkpoint $INIT_CHECKPOINT \
    #  --save_dir $SAVE_DIR \
    #  --weight_sharing true \
    #  --bidirectional_context true \
    #  --use_pointer_network 2 \
    # --use_topic_trans_judge true \
    # --use_topic_evaluate true

uvicorn chat:app --host '0.0.0.0' --port 8080 --reload
    # --vocab_path $VOCAB_PATH \
    # --data_dir $DATA_DIR \
    # --data_type $DATA_TYPE \
    # --batch_size 1 \
    # --num_type_embeddings 3 \
    # --use_discriminator false \
    # --init_checkpoint $INIT_CHECKPOINT \
    # --save_dir $SAVE_DIR \
    # --weight_sharing true \
    # --bidirectional_context true \
    # --use_pointer_network 2 \
    # --use_topic_trans_judge true \
    # --use_topic_evaluate true