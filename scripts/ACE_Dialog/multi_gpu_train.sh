#!/bin/bash
set -ux
#sleep 5s
#SAVE_DIR=outputs/DSTC7_plato #1
#SAVE_DIR=outputs/ACE_Dialog_pointer2_context #1
#SAVE_DIR=outputs/PersonaChat_pointer2_context #1
SAVE_DIR=outputs/ACE_Dialog_pointer_context_ceshi
#SAVE_DIR=outputs/DSTC7_pointer2_context
#SAVE_DIR=outputs/DailyDialog_pointer2_context
#SAVE_DIR=outputs/DailyDialog_gpt
VOCAB_PATH=model/Bert/vocab.txt
#DATA_DIR=data/DailyDialog
#DATA_DIR=data/DSTC7_AVSD
#DATA_DIR=data/PersonaChat
DATA_DIR=data/ACE_Dialog
INIT_CHECKPOINT=model/PLATO
#INIT_CHECKPOINT=outputs/ACE_Dialog/best.model
#INIT_CHECKPOINT=outputs/ACE_Dialog_pointer2_context/best.model
#INIT_CHECKPOINT=outputs/DSTC7_pointer2_context/best.model
DATA_TYPE=multi_knowledge
#DATA_TYPE=multi
USE_VISUALDL=true

# CUDA environment settings.
#export CUDA_VISIBLE_DEVICES=0,1,2,3 #2
export CUDA_VISIBLE_DEVICES=2,3

# Paddle environment settings.
export FLAGS_fraction_of_gpu_memory_to_use=0.9
export FLAGS_eager_delete_scope=True
export FLAGS_eager_delete_tensor_gb=0.0
LD_LIBRARY_PATH=~/miniconda3/envs/plato/lib/:/home/bool_tbb/jupyter_notebook/baidu_conv/paddleserver/include
export LD_LIBRARY_PATH




if [[ ! -e $DATA_DIR/dial.train.jsonl ]]; then
    python -u \
        ./preprocess.py \
        --vocab_path $VOCAB_PATH \
        --data_dir $DATA_DIR \
        --data_type $DATA_TYPE
fi

if [[ "$USE_VISUALDL" = true ]]; then
    visualdl --logdir=$SAVE_DIR/summary --port=6091 --host=0.0.0.0 &
    VISUALDL_PID=$!
fi

python -m \
    paddle.distributed.launch \
    --log_dir $SAVE_DIR \
    --started_port 6521 \
    ./run.py \
    --use_data_distributed true \
    --do_train true \
    --do_chat false \
    --vocab_path $VOCAB_PATH \
    --data_dir $DATA_DIR \
    --data_type $DATA_TYPE \
    --batch_size 2 \
    --valid_steps 2000 \
    --num_type_embeddings 3 \
    --use_discriminator false \
    --num_epoch 100 \
    --lr 1e-5 \
    --save_checkpoint false \
    --save_summary $USE_VISUALDL \
    --save_dir $SAVE_DIR \
    --bidirectional_context false \
    --weight_sharing true \
    --init_checkpoint $INIT_CHECKPOINT \
    --use_pointer_network -1 \
    --use_topic_trans_judge false \
    --use_topic_evaluate false
    
if [[ $USE_VISUALDL = true ]]; then
    kill $VISUALDL_PID
fi
