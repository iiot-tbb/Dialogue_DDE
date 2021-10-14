# 实验记录
## 20210928,内存溢出，设置的是最大句子长度是256,所以要检验一下这个问题。
## uni-transformer的最长长度是256,比较一下是哪个更长一些

## 20210930 导出了知识图谱中的实体和边的信息。
## duconv的数据是机器人先发问，因此训练的时候需要注意。
## duRecdical 有机器人主动发问的，也有人主动发问的
## KG中的实体和关系
### 实体类型标识:www.acekg.cn/concept/
### 边类型标识

- www.acekg.cn/property/
- www.acekg.cn/relation/
## 20211001,记录用到的虚拟环境：
- plato
- plato_ceshi 可以跑mutil_gpu
- palto_abs 增加了summarize的模块，看是否影响到了plato环境


## 20211002,在编写数据集的时候，遇到很多重名的人，因此我打算先忽略那些人名相同人的，只考虑不同姓名人，
### 在编写对话数据的时候，可以将那些用不到的字段剔除掉。

## 20211005:可以去掉的字段
- label
- sameas
- preflabel
- url或page中的一项
- tag
### 突然想到可以增加一个判断知识是否是正确的知识来扩大训练任务。

## 20211009，特殊标记[INTRODUCTION]当文本太长时做替换，为了拿到部分语意信息，可以做缩略版的intro
## 加入一个学习任务判断知识是否属于当前knowledge。
# 文件说明

## `chat.py`:对话文件，生成的对话聊天
## `../data_en/Baidu_text_transAPI.py`:将中文数据翻译成英文
## `../data_en/Transform_to_plate_form.py`:将`json`格式的文本转换问纯文本形式,方便后续模型处理
## `../data_en/get_DDE_Data.py`:取得实验室数据中的三元组数据
## `../data_en/duconvEn_tran.txt`知识对话数据
## `../data_en/make_abstract`缩短摘要的长度
## `../make_dialog.py`:制作对话数据
## ``
# 修改记录


# 采用的造对话数据的方式

- 给出关于某个知识的三元组信息，一问一答回复。
- 接入翻译API，我说一句中文，翻译成英文。
- 存到某一个文件中。
