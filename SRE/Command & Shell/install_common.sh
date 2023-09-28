#!/bin/sh

#############################################
##	基础配置
#############################################
##场景	1：不带管理后台	 2：带管理后台
scene=1

##public:公有云类型, private:私有云
cloud_flag=private

##私有云管理后台,场景2时必须配置
manager_ip=10.0.1.89
manager_port=8080
##公有云oam地址,场景2时必须配置
tx_cloud_url=10.0.1.206

##部署服务器的IP地址
server_ip=10.0.1.89

##appkey & devkey (只有私有云且不带管理后台方式时需要配置)
app_key="4c5d548a"
dev_key="40ff7ebfb952b623149688eac84cc68b"

##领域,必须设置
domain_code="1000"

##服务发现方式, 0-组播方式  1-zookeeper方式
server_sense=0
#zookeeper服务地址, zookeeper方式下，必须配置; 格式：10.0.1.10:2181,10.0.1.11:2181,10.0.1.12:2181
zookeeper_server=10.0.1.125:2181

##redis服务,必须设置
redis_ip=10.0.1.89
redis_port=6379
#认证密码，空表示不验证；请和redis服务部署时的配置一致。建议设置密码
redis_auth=""

##是否使用负载服务(SLB)；使用SLB，本机不一定需要部署SLB，可使用其他机器的SLB。
use_slb=yes

##mongodb数据库链接串，格式: mongodb://10.0.1.129:10101/ 
##注意：使用生物识别服务(afr、fpr、vpr)时，必须配置mongodb数据库。
bio_db_conn_str=""

##调度模块(TD)
td_need=yes
td_service_code=request1

##HTTP接口服务
http_need=yes
http_thread_num=4
http_access_port=8888
http_access_thread_num=16
http_request_port=8880
http_request_thread_num=32
http_service_code=http1

##SOCKET接口服务
socket_need=no
socket_thread_num=32
socket_service_code=socket1

##MRCP接口服务
mrcp_need=no
mrcp_thread_num=4
mrcp_sip_port=5060
mrcp_port=1644
#提供的资源,(格式：asr;tts;vpr) 目前支持asr、tts、vpr
mrcp_resources="asr;tts;vpr"
mrcp_service_code=mrcp1

##负载服务(SLB)
slb_need=yes
slb_thread_num=24
#负载策略 1-各个能力服务器带权重轮询，2-根据cpu空闲情况选择(需要本地控制服务的支持)，3-空闲线程数
slb_load_policy=1
slb_service_code=slb1

##授权服务(LICENSE_SERVER)
license_server_need=yes
license_server_thread_num=32
#授权模式 0:硬授权,1:软授权,2:IP软授权
license_server_mode=1
license_server_priority=80
license_server_service_code=license1

##本地控制(LOCAL_CONTROL)
local_control_need=no
local_control_thread_num=4
#接收控制命令的端口
local_control_cmd_port=9005
local_control_service_code=local1

##ASR服务
asr_need=no
asr_thread_num=32
#是否支持流转
asr_post_process=no
#流转到的broker地址，支持流转时必须配置
asr_broker_addr="http://10.0.1.89:8090/broker"
asr_service_code=asr1

##ASR_Dialog服务
asr_dialog_need=no
asr_dialog_thread_num=32
asr_dialog_service_code=asr1

##NLU服务
nlu_need=no
#工作线程数
nlu_thread_num=32
nlu_service_code=nlu1
#dialog识别线程数
nlu_dialog_threads_num=5
#访问内容平台的线程数,必须小于上面配置的nlu_thread_num
nlu_content_threads_num=16
#异步处理同步请求和训练请求的线程
nlu_async_threads_num=5
#内容平台地址，用于获取意图的内容，为空时，表示不支持获取意图内容；格式: http://10.0.1.209:26000
nlu_ContentQueryUrl=

##NLU_SYNC服务
nlu_sync_need=no
nlu_sync_thread_num=32
#nlu服务列表，(格式：10.0.1.100:17000;10.0.1.101:17000)
nlu_server_list=10.0.1.89:17000
nlu_sync_service_code=nlu_sync1

##TTS服务
tts_need=no
tts_thread_num=32
tts_service_code=tts1

##OCR_TEMPLATE服务
ocr_template_need=no
ocr_template_thread_num=32
ocr_template_service_code=ocr_template1

##OCR_BANKCARD服务
ocr_bankcard_need=no
ocr_bankcard_thread_num=32
ocr_bankcard_service_code=ocr_bankcard1

##OCR_BIZCARD服务
ocr_bizcard_need=no
ocr_bizcard_thread_num=32
ocr_bizcard_service_code=ocr_bizcard1

##OCR_TEXT服务
ocr_text_need=no
ocr_text_thread_num=32
ocr_text_service_code=ocr_text1

##OCR_BARCODE服务
ocr_barcode_need=no
ocr_barcode_thread_num=32
ocr_barcode_service_code=ocr_barcode1

##HWR服务
hwr_need=no
hwr_thread_num=32
hwr_service_code=hwr1

##MT服务
mt_need=no
mt_thread_num=32
mt_service_code=mt1

##AFR服务
afr_need=no
afr_thread_num=32
##启动多线处理多选一识别的模型规模的阈值
#    1) 请求的组中用户数(模型数)达到该阈值时，启动多线处理该请求，线程数由参数threads_num_for_1vsN决定。
#    2) (默认值)0:表示不开启多线处理。 
afr_models_num_threshold_for_1vsN=0
##多线处理多选一识别的线程数
#   1)启动多线处理多选一识别时，使用的线程数。
#   2)合理设置该参数，可以缩短单个请求处理时间，但会影响并发数
afr_threads_num_for_1vsN=2
afr_service_code=afr1

##FPR服务
fpr_need=no
fpr_thread_num=32
##启动多线处理多选一识别的模型规模的阈值
#    1) 请求的组中用户数(模型数)达到该阈值时，启动多线处理该请求，线程数由参数threads_num_for_1vsN决定。
#    2) (默认值)0:表示不开启多线处理。 
fpr_models_num_threshold_for_1vsN=0
##多线处理多选一识别的线程数
#   1)启动多线处理多选一识别时，使用的线程数。
#   2)合理设置该参数，可以缩短单个请求处理时间，但会影响并发数
fpr_threads_num_for_1vsN=2
fpr_service_code=fpr1

##VPR服务
vpr_need=no
vpr_thread_num=32
##启动多线处理多选一识别的模型规模的阈值
#    1) 请求的组中用户数(模型数)达到该阈值时，启动多线处理该请求，线程数由参数threads_num_for_1vsN决定。
#    2) (默认值)0:表示不开启多线处理。 
vpr_models_num_threshold_for_1vsN=0
##多线处理多选一识别的线程数
#   1)启动多线处理多选一识别时，使用的线程数。
#   2)合理设置该参数，可以缩短单个请求处理时间，但会影响并发数
vpr_threads_num_for_1vsN=2
vpr_service_code=vpr1

##模型同步服务(MODEL_SYNC)
model_sync_need=no
model_sync_thread_num=32
model_sync_service_code=model_sync1

##text_analyze服务
text_analyze_need=no
text_analyze_thread_num=4
text_analyze_service_code=text_analyze1

##ta_sync服务
ta_sync_need=no
ta_sync_thread_num=4
ta_sync_service_code=ta_sync1

##asr_trans服务
asr_trans_need=no
asr_trans_thread_num=4
asr_trans_service_code=asr_trans1

##安装目录
personal_dir="${HOME}/cloud/"

#############################################
##	常量
#############################################

global_generic_config_path=$HOME"/cloud/common/conf/hcicloud.conf"
#修改request的配置
request_config_path=$HOME"/cloud/common/conf/request.conf"
slb_config_path=$HOME"/cloud/slb/conf/hcicloud_slb.conf"
nlu_config_path=$HOME"/cloud/nlu/conf/hcicloud_nlu.conf"
asr_trans_config_path=$HOME"/cloud/asr_trans/conf/hcicloud_asr_trans.conf"
asr_dialog_config_path=$HOME"/cloud/asr_dialog/conf/hcicloud_asr_dialog.conf"
tts_config_path=$HOME"/cloud/tts/conf/hcicloud_tts.conf"
hwr_config_path=$HOME"/cloud/hwr/conf/hcicloud_hwr.conf"
mt_config_path=$HOME"/cloud/mt/conf/hcicloud_mt.conf"
ocr_config_path=$HOME"/cloud/ocr/conf/hcicloud_ocr.conf"
asr_grammar_config_path=$HOME"/cloud/asr_grammar/conf/hcicloud_asr_grammar.conf"
license_server_config_path=$HOME"/cloud/license_server/conf/hcicloud_license_server.conf"
ocr_template_config_path=$HOME"/cloud/ocr_template/conf/hcicloud_ocr_template.conf"
ocr_bankcard_config_path=$HOME"/cloud/ocr_bankcard/conf/hcicloud_ocr_bankcard.conf"
ocr_bizcard_config_path=$HOME"/cloud/ocr_bizcard/conf/hcicloud_ocr_bizcard.conf"
ocr_text_config_path=$HOME"/cloud/ocr_text/conf/hcicloud_ocr_text.conf"
ocr_barcode_config_path=$HOME"/cloud/ocr_barcode/conf/hcicloud_ocr_barcode.conf"
#hwr_config_path=$HOME"/cloud/hwr/hcicloud_hwr/conf/hcicloud_hwr.conf"
http_config_path=$HOME"/cloud/http_server/conf/hcicloud_http_server.conf"
socket_config_path=$HOME"/cloud/request_agent/conf/hcicloud_request_agent.conf"
mrcp_config_path=$HOME"/cloud/mrcp_svc/conf/hcicloud_mrcp_svc.conf"
asr_cp_config_path=$HOME"/cloud/asr_cp/conf/hcicloud_asr_cp.conf"
local_control_config_path=$HOME"/cloud/local_control/conf/hcicloud_local_control.conf"
nlu_sync_config_path=$HOME"/cloud/nlu_sync/conf/hcicloud_nlu_sync.conf"
vpr_config_path=$HOME"/cloud/vpr/conf/hcicloud_vpr.conf"
fpr_config_path=$HOME"/cloud/fpr/conf/hcicloud_fpr.conf"
afr_config_path=$HOME"/cloud/afr/conf/hcicloud_afr.conf"
model_sync_config_path=$HOME"/cloud/model_sync/conf/hcicloud_model_sync.conf"
text_analyze_config_path=$HOME"/cloud/text_analyze/conf/hcicloud_text_analyze.conf"
ta_sync_config_path=$HOME"/cloud/ta_sync/conf/hcicloud_ta_sync.conf"


#############################################
##	用到的中间变量
#############################################



#############################################
##	函数
#############################################

function if_file_exist()
{
	if [ $# -ne 1 ];then
		echo "请输入要检测的文件名"
		return 0;
	else
		#开始检测文件是否存在	
		if [ -f $1 ];then
			return 1;
		else
			return 0
		fi	
	fi
}

function yes_or_no()
{
	read -e y_o_n
	#转换为大写
	y_o_n=$(echo $y_o_n | tr [a-z] [A-Z])
	while [ "$y_o_n" != "Y" -a "$y_o_n" != "N" ];do
        	echo "请正确输入(y or n),不区分大小写"
	        read -e y_o_n
        	#转换为大写
		y_o_n=$(echo $y_o_n | tr [a-z] [A-Z])
	done
	if [ "$y_o_n" == "Y" ];then
        	return 1
	else
		return 0
	fi
}

function input_mk_sure()
{
	if [ "$1"X = "X" ]; then
        echo "Paramter of input_mk_sure invalid!"
		exit 1
    fi	

    cmd="echo \$$1"
    __var_value__=`eval $cmd`

    echo "您输入的是$__var_value__,确定吗?(y/n)"
    yes_or_no
    while [ $? -ne 1 ]
    do 
        echo "请重新输入"
        read -e __var_value__
        echo "您输入的是$__var_value__,确定吗?(y/n)"
        yes_or_no
    done

    cmd="$1=\$__var_value__"
    eval $cmd

    return 0
}

#############################################
##	交互配置
#############################################
interactive=yes

for i in $@
do
	if [ "$i"X = "-s"X ]; then
		interactive=no
	elif [ "$i"X = "-h"X ]; then
		echo "用法：$0 [-s]"
		echo "-s: 非交互模式"
		echo "默认: 交互模式"
		exit 0
	fi
done

echo "开始安装灵云能力平台，请将安装包放置到，与本安装脚本相同的目录下。"

#交互安装模式
if [ "$interactive"X = "yes"X ]; then

	echo "安装支持交互模式和非交互模式。"
	echo "当前是交互安装模式，需要交互输入服务配置信息。"
	echo "如果要使用非交互模式，请输入y, 然后vim编辑install_common.sh,修改基础配置部分，保存后，执行脚本./install_common.sh -s"
	echo "继续使用交互模式，请输入n"
	yes_or_no
	if [ $? -eq 1 ]; then
		exit 0
	fi
	
	echo "------------------开始配置灵云能力平台------------------------"
	#场景定义
	echo "请选择部署场景,输入1(不带管理后台) 或者 2(带管理后台)"
	read -e scene
	input_mk_sure scene

	if [ $scene -eq 1 ];then
		echo "请输入领域"
		read -e domain_code
		input_mk_sure domain_code
		
	else
		#如果是场景2，则需要输入管理后台的url及端口
		echo "请输入管理后台的Ip地址"
		read -e manager_ip
		input_mk_sure manager_ip

		echo "管理后台的访问端口默认为${manager_port},是否修改?(y/n)"
		yes_or_no
		if [ $? -eq 1 ]; then
			echo "请输入管理后台的访问端口"
			read -e manager_port
			input_mk_sure manager_port
		fi
	fi
	
	#服务IP地址
	echo "请输入部署服务器的IP地址"
	read -e server_ip
	input_mk_sure server_ip

	if [ $scene -eq 1 ];then
		#appkey & devkey
		echo "默认appkey是${app_key},是否修改?(y/n)"
		yes_or_no
		if [ $? -eq 1 ]; then
			echo "请输入捷通提供的appkey:"
			read -e app_key
			input_mk_sure app_key	
		fi	
		#所有的dev_key暂时都定死为developer_key了
		#echo "请输入捷通提供的developer_key"
		#read -e dev_key
		#input_mk_sure dev_key

		#server_sense 0-组播方式 1-zookeeper方式
        server_sense_string="组播方式"
        if [ $server_sense -eq 1 ]; then
            server_sense_string="zookeeper方式"
        fi
		echo "默认服务发现方式是${server_sense_string},是否修改?(y/n)"
		yes_or_no
		if [ $? -eq 1 ]; then
			echo "请输入服务发现方式,(0-组播方式 1-zookeeper方式):"
			read -e server_sense
			input_mk_sure server_sense
		fi	
        if [ $server_sense -eq 1 ]; then
            echo "请输入zookeeper服务地址，格式：10.0.1.10:2181,10.0.1.11:2181,10.0.1.12:2181"
            read -e zookeeper_server
            input_mk_sure zookeeper_server
        fi

		#redis服务
		echo "请输入redis服务的ip地址:"
		read -e redis_ip
		input_mk_sure redis_ip
		echo "redis服务的默认端口是${redis_port},是否修改?(y/n)"
		yes_or_no
		if [ $? -eq 1 ]; then
			echo "请输入访问的redis的port, (请和redis服务配置保持一致)"
			read -e redis_port
			input_mk_sure redis_port
		fi		
		echo "是否需要设置redis认证密码(y or n) (请和redis服务配置保持一致)"
		yes_or_no
		if [ "$?" -eq 1 ];then
			echo "请输入认证密码"
			read -e redis_auth
			input_mk_sure redis_auth
		fi

		#mongodb
		echo "是否使用mongodb数据库?(y/n)  注意：使用生物识别服务(afr、fpr、vpr)时，必须使用mongodb数据库。"
		yes_or_no
		if [ $? -eq 1 ]; then
			echo "请输入mongodb链接地址(格式:mongodb://10.0.1.129:10101/)"
			read -e bio_db_conn_str
			input_mk_sure bio_db_conn_str
		fi	
	fi
	
	#是否使用负载服务(SLB)
	echo "是否使用负载服务(SLB)? (y or n) 注意：使用SLB，并不一定要在本机部署SLB，可以使用其他机器上的SLB。"
	yes_or_no
	if [ "$?" -eq 1 ];then
		use_slb=yes
	else
		use_slb=no
	fi
		
	#license_server
	echo "是否需要部署license_server服务?(y/n)"
	yes_or_no
	if [ "$?" -eq 1 ];then
		license_server_need=yes	
		echo "开始配置license_server服务..."
		if [ "$scene" -eq 1 ];then
	#--------------------------------------------------------------------------------------------------------license server场景1		
			#线程池中的线程数目
			echo "请输入启动线程数(建议根据授权并发情况尽量设置大值,如128)"
			read -e license_server_thread_num
			input_mk_sure license_server_thread_num

			echo "请输入授权模式,0:硬授权,1:软授权,2:IP软授权"
			read -e license_server_mode
			input_mk_sure license_server_mode

			#修改授权服务器的权重信息
			echo "请输入本授权服务器的权重(权重决定了授权服务器的主备顺序)"
			read license_server_priority
			input_mk_sure license_server_priority
		else
	#--------------------------------------------------------------------------------------------------------license server场景2
			echo "请输入license server在管理后台中的service code"
			read -e license_server_service_code
			input_mk_sure license_server_service_code
		fi
		echo "license_server服务配置完成。"
		echo ""
	else
		license_server_need=no
	fi

	#local_control
	echo "是否需要部署本地控制服务local_control服务?(y/n)"
	yes_or_no
	if [ "$?" -eq 1 ];then
		local_control_need=yes
		echo "开始配置local_control服务..."
		if [ "$scene" -eq 1 ];then
	#-------------------------------------------------------------------------------------------------------local control场景1
			#线程池中的线程数目
			echo "请输入启动线程数(仅仅处理一些查询消息，设置为5线左右即可)"
			read -e local_control_thread_num
			input_mk_sure local_control_thread_num

			#修改接收控制命令的端口(建议为9005)
			echo "本地控制服务接收控制命令的端口默认为${local_control_cmd_port},是否修改?(y/n)"
			yes_or_no
			if [ $? -eq 1 ]; then
				echo "请输入端口:"
				read -e local_control_cmd_port
				input_mk_sure local_control_cmd_port
			fi	
		else 
	#--------------------------------------------------------------------------------------------------------local control场景2
			echo "请输入local control在管理后台中的service code"
			read -e local_control_service_code
			input_mk_sure local_control_service_code
		fi
		echo "local_control服务配置完成。"
		echo ""
	else
		local_control_need=no
	fi
	
	#td调度的相关配置信息
	echo "是否需要部署调度模块?(y or n) 注意：需要部署http server接口服务 或者 socket接口服务 或者 mrcp接口服务时， 必须部署调度模块。"
	yes_or_no
	if [ "$?" -eq 1 ];then
		td_need=yes
		echo "开始配置调度模块..."
		if [ "$scene" -eq 2 ];then
	#---------------------------------------------------------------------------------------------------td场景2
			echo "请输入调度模块在管理后台中的service code"
			read -e td_service_code
			input_mk_sure td_service_code
		fi
		echo "调度模块配置完成。"
		echo ""
	else
		#仅单个能力的部署
		td_need=no
	fi
	
	#http server 接口
	echo "是否需要部署http server 接口服务?(y or n)"
	yes_or_no
	if [ "$?" -eq 1 ];then
		http_need=yes
		echo "开始配置http server 接口服务..."
		if [ "$scene" -eq 1 ];then
	#---------------------------------------------------------------------------------------------------http server场景1
			echo "请输入启动线程数(仅仅处理一些查询消息，设置为5线左右即可)"
			read -e http_thread_num
			input_mk_sure http_thread_num

			echo "http server提供授权服务的端口默认为${http_access_port},是否修改?(y or n)"
			yes_or_no
			if [ $? -eq 1 ]; then
				echo "请输入端口:"
				read -e http_access_port
				input_mk_sure http_access_port
			fi

			echo "请输入http server提供授权服务的线程数(根据授权实际并发情况输入,如32)"
			read -e http_access_thread_num
			input_mk_sure http_access_thread_num

			echo "http server提供识别服务的端口默认为${http_request_port},是否修改?(y or n)"
			yes_or_no
			if [ $? -eq 1 ]; then
				echo "请输入端口:"
				read -e http_request_port
				input_mk_sure http_request_port
			fi			
			
			echo "请输入http server提供识别服务的线程数(根据识别实际并发情况输入,如128)"
			read -e http_request_thread_num
			input_mk_sure http_request_thread_num
		else
	#---------------------------------------------------------------------------------------------------http server场景2
			echo "请输入http server 接口服务在管理后台中的service code"
			read -e http_service_code
			input_mk_sure http_service_code
		fi
		echo "http server接口服务配置完成。"
		echo ""
	else
		#不用http server服务的逻辑
		echo "不使用http server 接口服务"
		http_need=no
	fi
	
	#socket server 接口
	echo "是否需要部署socket server 接口服务(y or n)?"
	yes_or_no
	if [ "$?" -eq 1 ];then
		socket_need=yes
		echo "开始配置socket server 接口服务..."
		if [ "$scene" -eq 1 ];then
	#---------------------------------------------------------------------------------------------------socket server场景1
			echo "请输入启动线程数(根据并发处理情况输入，如128)"
			read -e socket_thread_num
			input_mk_sure socket_thread_num
		else
	#---------------------------------------------------------------------------------------------------socket server场景2
			echo "请输入socket server 接口服务在管理后台中的service code"
			read -e socket_service_code
			input_mk_sure socket_service_code
		fi
		echo "socket server 接口服务配置完成。"
		echo ""
	else
		#不用socket server服务的逻辑
		echo "不使用socket server 接口服务"
		socket_need=no
	fi 

	#mrcp server 接口
	echo "是否需要部署mrcp server 接口服务(y or n)?"
	yes_or_no
	if [ "$?" -eq 1 ];then
		mrcp_need=yes
		echo "开始配置mrcp server 接口服务..."
		if [ "$scene" -eq 1 ];then
	#---------------------------------------------------------------------------------------------------mrcp server场景1
			echo "请输入启动线程数(根据并发处理情况输入，如128)"
			read -e mrcp_thread_num
			input_mk_sure mrcp_thread_num

			#sip端口建议为5060"
			echo "sip端口号默认为${mrcp_sip_port},是否修改?(y or n)"
			yes_or_no
			if [ $? -eq 1 ]; then
				echo "请输入端口号:"
				read -e mrcp_sip_port
				input_mk_sure mrcp_sip_port
			fi
			
			#mrcp端口建议为1644"
			echo "mrcp端口号默认为${mrcp_port},是否修改?(y or n)"
			yes_or_no
			if [ $? -eq 1 ]; then
				echo "请输入端口:"
				read -e mrcp_port
				input_mk_sure mrcp_port
			fi		

			echo "请输入MRCP服务器所提供的资源,(格式：asr;tts;vpr) 目前支持asr、tts、vpr"
			read -e mrcp_resources
			input_mk_sure mrcp_resources
		else
	#---------------------------------------------------------------------------------------------------mrcp server场景2
			echo "请输入mrcp server 接口服务在管理后台中的service code"
			read -e mrcp_service_code
			input_mk_sure mrcp_service_code
		fi
		echo "mrcp server 接口服务配置完成。"
		echo ""
	else
		#不用mrcp server服务的逻辑
		echo "不使用mrcp server 接口服务"
		mrcp_need=no
	fi
	
	#开始配置负载服务
	echo "是否需要部署负载服务(y or n)?"
	yes_or_no
	if [ "$?" -eq 1 ];then
		slb_need=yes
		echo "开始配置负载服务..."
		if [ "$scene" -eq 1 ];then
	#---------------------------------------------------------------------------------------------------slb场景1
			#线程池中的线程数目
			echo "请输入启动线程数(接收调度查询及注册请求，建议设置为请求并发的一半)"
			read -e slb_thread_num
			input_mk_sure slb_thread_num

			#负载策略的选择
			echo "请选择负载策略，1:各个能力服务器带权重轮询，2:根据cpu空闲情况选择(需要本地控制服务的支持)，3:空闲线程数"
			read -e slb_load_policy
			input_mk_sure slb_load_policy
		else
	#---------------------------------------------------------------------------------------------------slb场景2
			echo "请输入负载服务在管理后台中的service code"
			read -e slb_service_code
			input_mk_sure slb_service_code
		fi
		echo "负载服务配置完成。"
		echo ""
	else
		#不用负载服务的逻辑
		echo "不使用负载服务"
		slb_need=no
	fi
	
	#nlu
	echo "是否需要部署nlu服务?(y or n)"
	yes_or_no
	if [ "$?" -eq 1 ];then
		nlu_need=yes
		#配置nlu服务
		echo "开始配置nlu服务..."
		#---------------------------------------------------------------------------------------------------------nlu场景1
		if [ "$scene" -eq 1 ];then
			#线程池中的线程数目
			echo "请输入启动线程数(根据并发处理情况输入，如32)"
			read -e nlu_thread_num
			input_mk_sure nlu_thread_num

			#dialog识别的线程数
			echo "请输入单个请求的dialog识别的线程数(根据并发处理情况输入，如4)"
			read -e nlu_dialog_threads_num
			input_mk_sure nlu_dialog_threads_num
		
			#访问内容平台的线程数
			echo "请输入访问内容平台的线程数(根据并发处理情况输入，如16)"
			read -e nlu_content_threads_num
			input_mk_sure nlu_content_threads_num
		
			#异步处理同步和训练的线程数
			echo "请输入异步处理同步或训练的线程数(根据并发处理情况输入，如4)"
			read -e nlu_async_threads_num
			input_mk_sure nlu_async_threads_num

			#内容平台地址
			echo "请输入内容平台地址(根据实际情况输入，为空是表示不支持获取意图内容，格式：http://10.0.1.209:26000 )"
			read -e nlu_ContentQueryUrl
			input_mk_sure nlu_ContentQueryUrl
		
		else
		#---------------------------------------------------------------------------------------------------------nlu场景2
			echo "请输入nlu服务在管理后台中的service code"
			read -e nlu_service_code
			input_mk_sure nlu_service_code
		fi
		echo "nlu服务配置完成。"
		echo ""
	else
		nlu_need=no
	fi
	
	#nlu_sync
	echo "是否需要部署nlu_sync服务?(y or n)"
	yes_or_no
	if [ "$?" -eq 1 ];then
		nlu_sync_need=yes
		#配置nlu_sync服务
		echo "开始配置nlu_sync服务..."
		#---------------------------------------------------------------------------------------------------------nlu_sync场景1
		if [ "$scene" -eq 1 ];then
			#线程池中的线程数目
			echo "请输入启动线程数(根据并发处理情况输入，如128)"
			read -e nlu_sync_thread_num
			input_mk_sure nlu_sync_thread_num
			
			#配置nlu服务列表
			echo "请输入nlu服务列表，(格式：10.0.1.100:17000;10.0.1.101:17000)"
			read -e nlu_server_list
			input_mk_sure nlu_server_list		
		else
		#---------------------------------------------------------------------------------------------------------nlu_sync场景2
			echo "请输入nlu_sync服务在管理后台中的service code"
			read -e nlu_sync_service_code
			input_mk_sure nlu_sync_service_code
		fi
		echo "nlu_sync服务配置完成。"
		echo ""
	else
		nlu_sync_need=no
	fi
	
	#asr_cp
	echo "是否需要部署asr_cp服务?(y/n)"
	yes_or_no
	if [ "$?" -eq 1 ];then
		asr_need=yes
		#配置asr_cp服务
		echo "开始配置asr_cp服务..."
		if [ "$scene" -eq 1 ];then
	#---------------------------------------------------------------------------------------------------------asr_cp场景1
			#线程池中的线程数目
			echo "请输入启动线程数(根据并发处理情况输入，如128)"
			read -e asr_thread_num
			input_mk_sure asr_thread_num
	
			#是否支持流转asr_post_process
			echo "是否支持流转?(y/n)"
			yes_or_no
			if [ "$?" -eq 1 ];then
				#设置是否支持流转
				asr_post_process=yes
				#设置broker地址
				echo "请输入broker_addr的地址"
				read -e asr_broker_addr
				input_mk_sure asr_broker_addr
			else
				asr_post_process=no
			fi
		else
	#-----------------------------------------------------------------------------------------------------------asr_cp场景2
			echo "请输入asr服务在管理后台中的service code"
			read -e asr_service_code
			input_mk_sure asr_service_code
		fi
		echo "asr_cp服务配置完成。"
		echo ""
	else
		asr_need=no
	fi
	
	#asr_dialog
	echo "是否需要部署asr_dialog服务?(y/n)"
	yes_or_no
	if [ "$?" -eq 1 ];then
		asr_dialog_need=yes
		#配置asr_dialog服务
		echo "开始配置asr_dialog服务..."
		if [ "$scene" -eq 1 ];then
	#---------------------------------------------------------------------------------------------------------asr_dialog场景1
			#线程池中的线程数目
			echo "请输入启动线程数(根据并发处理情况输入，如128)"
			read -e asr_dialog_thread_num
			input_mk_sure asr_dialog_thread_num
		else
	#-----------------------------------------------------------------------------------------------------------asr_dialog场景2
			echo "请输入asr_dialog服务在管理后台中的service code"
			read -e asr_dialog_service_code
			input_mk_sure asr_dialog_service_code
		fi
		echo "asr_dialog服务配置完成。"
		echo ""
	else
		asr_dialog_need=no
	fi
	
	#vpr
	echo "是否需要部署vpr服务?(y/n)"
	yes_or_no
	if [ "$?" -eq 1 ];then
		vpr_need=yes
		#配置vpr服务
		echo "开始配置vpr服务..."
		if [ "$scene" -eq 1 ];then
	#---------------------------------------------------------------------------------------------------------vpr场景1	
			#线程池中的线程数目
			echo "请输入启动线程数(根据并发处理情况输入，如128)"
			read -e vpr_thread_num
            input_mk_sure vpr_thread_num

			#多选一识别，启动多线处理的模型规模的阈值
			echo "多选一识别，启动多线处理的模型规模的阈值"
			echo "注意：1) 阈值决定请求的组中模型数达到多少时，启动多线处理；"
			echo "      2) (默认值)0:表示不开启多线处理。"
			echo "是否设置该阈值，开启多线处理多选一识别？(y/n)"
            yes_or_no
            if [ "$?" -eq 1 ]; then
			    echo "请输入阈值："
			    read -e vpr_models_num_threshold_for_1vsN
			    input_mk_sure vpr_models_num_threshold_for_1vsN

                #多选一识别, 启动多线处理的线程数
			    echo "多选一识别，启动多线处理的线程数"
			    echo "注意：合理设置该参数，可以缩短单个请求处理时间，但会影响并发数"
			    echo "默认线程数为${vpr_threads_num_for_1vsN},是否修改？(y/n)"
                yes_or_no
                if [ "$?" -eq 1 ]; then
			        echo "请输入线程数："
			        read -e vpr_threads_num_for_1vsN
			        input_mk_sure vpr_threads_num_for_1vsN
                fi
            fi
		else
	#-----------------------------------------------------------------------------------------------------------vpr场景2
			echo "请输入vpr服务在管理后台中的service code"
			read -e vpr_service_code
			input_mk_sure vpr_service_code
		fi
		echo "vpr服务配置完成。"
		echo ""
	else
		vpr_need=no
	fi
	
	#fpr
	echo "是否需要部署fpr服务?(y/n)"
	yes_or_no
	if [ "$?" -eq 1 ];then	
		fpr_need=yes
		#配置fpr服务
		echo "开始配置fpr服务..."
		if [ "$scene" -eq 1 ];then
	#---------------------------------------------------------------------------------------------------------fpr场景1
			#线程池中的线程数目
			echo "请输入本服务的启动线程数(根据并发处理情况输入，如128)"
			read -e fpr_thread_num
			input_mk_sure fpr_thread_num
            
            #多选一识别，启动多线处理的模型规模的阈值
            echo "多选一识别，启动多线处理的模型规模的阈值"
            echo "注意：1) 阈值决定请求的组中模型数达到多少时，启动多线处理；"
            echo "      2) (默认值)0:表示不开启多线处理。"
            echo "是否设置该阈值，开启多线处理多选一识别？(y/n)"
            yes_or_no
            if [ "$?" -eq 1 ]; then
                echo "请输入阈值："
                read -e fpr_models_num_threshold_for_1vsN
                input_mk_sure fpr_models_num_threshold_for_1vsN

                #多选一识别, 启动多线处理的线程数
                echo "多选一识别，启动多线处理的线程数"
                echo "注意：合理设置该参数，可以缩短单个请求处理时间，但会影响并发数"
                echo "默认线程数为${fpr_threads_num_for_1vsN},是否修改？(y/n)"
                yes_or_no
                if [ "$?" -eq 1 ]; then
                    echo "请输入线程数："
                    read -e fpr_threads_num_for_1vsN
                    input_mk_sure fpr_threads_num_for_1vsN
                fi  
            fi  
		else
	#-----------------------------------------------------------------------------------------------------------fpr场景2
			echo "请输入fpr服务在管理后台中的service code"
			read -e fpr_service_code
			input_mk_sure fpr_service_code
		fi
		echo "fpr服务配置完成。"
		echo ""
	else
		fpr_need=no
	fi
	
	#afr
	echo "是否需要部署afr服务?(y/n)"
	yes_or_no
	if [ "$?" -eq 1 ];then
		afr_need=yes
		#配置afr服务
		echo "开始配置afr服务..."
		if [ "$scene" -eq 1 ];then
	#---------------------------------------------------------------------------------------------------------afr场景1	
			#线程池中的线程数目
			echo "请输入本服务的启动线程数(根据并发处理情况输入，如128)"
			read -e afr_thread_num
			input_mk_sure afr_thread_num

            #多选一识别，启动多线处理的模型规模的阈值
            echo "多选一识别，启动多线处理的模型规模的阈值"
            echo "注意：1) 阈值决定请求的组中模型数达到多少时，启动多线处理；"
            echo "      2) (默认值)0:表示不开启多线处理。"
            echo "是否设置该阈值，开启多线处理多选一识别？(y/n)"
            yes_or_no
            if [ "$?" -eq 1 ]; then
                echo "请输入阈值："
                read -e afr_models_num_threshold_for_1vsN
                input_mk_sure afr_models_num_threshold_for_1vsN

                #多选一识别, 启动多线处理的线程数
                echo "多选一识别，启动多线处理的线程数"
                echo "注意：合理设置该参数，可以缩短单个请求处理时间，但会影响并发数"
                echo "默认线程数为${afr_threads_num_for_1vsN},是否修改？(y/n)"
                yes_or_no
                if [ "$?" -eq 1 ]; then
                    echo "请输入线程数："
                    read -e afr_threads_num_for_1vsN
                    input_mk_sure afr_threads_num_for_1vsN
                fi
            fi
		else
	#-----------------------------------------------------------------------------------------------------------afr场景2
			echo "请输入afr服务在管理后台中的service code"
			read -e afr_service_code
			input_mk_sure afr_service_code
		fi
		echo "afr服务配置完成。"
		echo ""
	else
		afr_need=no
	fi
	
	#model_sync
	echo "是否需要部署model_sync服务?(y/n) 注意:部署多个生物识别服务(afr、fpr、fpr)时，需要部署model_sync。"
	yes_or_no
	if [ "$?" -eq 1 ];then
		model_sync_need=yes
		#配置model_sync服务
		echo "开始配置model_sync服务..."
		if [ "$scene" -eq 1 ];then
	#---------------------------------------------------------------------------------------------------------model_sync 场景1
			#线程池中的线程数目
			echo "请输入启动线程数(根据并发处理情况输入，如128)"
			read -e model_sync_thread_num
			input_mk_sure model_sync_thread_num
		else
	#-----------------------------------------------------------------------------------------------------------model_sync 场景2
			echo "请输入model_sync服务在管理后台中的service code"
			read -e model_sync_service_code
			input_mk_sure model_sync_service_code
		fi
		echo "model_sync服务配置完成。"
		echo ""
	else
		model_sync_need=yes
	fi

	#ocr_template
	echo "是否需要部署ocr_template服务?(y/n)"
	yes_or_no
	if [ "$?" -eq 1 ];then
		ocr_template_need=yes
		#配置ocr_template服务
		echo "开始配置ocr_template服务..."
		if [ "$scene" -eq 1 ];then
	#---------------------------------------------------------------------------------------------------------ocr_template场景1
			#线程池中的线程数目
			echo "请输入启动线程数(根据并发处理情况输入，如128)"
			read -e ocr_template_thread_num
			input_mk_sure ocr_template_thread_num
		else
	#-----------------------------------------------------------------------------------------------------------ocr_template场景2
			echo "请输入ocr_template服务在管理后台中的service code"
			read -e ocr_template_service_code
			input_mk_sure ocr_template_service_code
		fi
		echo "orc_template服务配置完成。"
		echo ""
	else
		ocr_template_need=no
	fi

	#ocr_bankcard
	echo "是否需要部署ocr_bankcard服务?(y/n)"
	yes_or_no
	if [ "$?" -eq 1 ];then
		ocr_bankcard_need=yes
		#配置ocr_bankcard服务
		echo "开始配置ocr_bankcard服务..."
		if [ "$scene" -eq 1 ];then
	#---------------------------------------------------------------------------------------------------------ocr_bankcard场景1
			#线程池中的线程数目
			echo "请输入启动线程数(根据并发处理情况输入，如128)"
			read -e ocr_bankcard_thread_num
			input_mk_sure ocr_bankcard_thread_num
		else
	#-----------------------------------------------------------------------------------------------------------ocr_bankcard场景2
			echo "请输入ocr_bankcard服务在管理后台中的service code"
			read -e ocr_bankcard_service_code
			input_mk_sure ocr_bankcard_service_code
		fi
		echo "orc_bankcard服务配置完成。"
		echo ""
	else
		ocr_bankcard_need=no
	fi

	#ocr_bizcard
	echo "是否需要部署ocr_bizcard服务?(y/n)"
	yes_or_no
	if [ "$?" -eq 1 ];then
		ocr_bizcard_need=yes
		#配置ocr_bizcard服务
		echo "开始配置ocr_bizcard服务..."
		if [ "$scene" -eq 1 ];then
	#---------------------------------------------------------------------------------------------------------ocr_bizcard场景1
			#线程池中的线程数目
			echo "请输入启动线程数(根据并发处理情况输入，如128)"
			read -e ocr_bizcard_thread_num
			input_mk_sure ocr_bizcard_thread_num
		else
	#-----------------------------------------------------------------------------------------------------------ocr_bizcard场景2
			echo "请输入ocr_bizcard服务在管理后台中的service code"
			read -e ocr_bizcard_service_code
			input_mk_sure ocr_bizcard_service_code
		fi
		echo "orc_bizcard服务配置完成。"
		echo ""
	else
		ocr_bizcard_need=no
	fi

	#ocr_text
	echo "是否需要部署ocr_text服务?(y/n)"
	yes_or_no
	if [ "$?" -eq 1 ];then
		ocr_text_need=yes
		#配置ocr_text服务
		echo "开始配置ocr_text服务..."
		if [ "$scene" -eq 1 ];then
	#---------------------------------------------------------------------------------------------------------ocr_text场景1
			#线程池中的线程数目
			echo "请输入启动线程数(根据并发处理情况输入，如128)"
			read -e ocr_text_thread_num
			input_mk_sure ocr_text_thread_num
		else
	#-----------------------------------------------------------------------------------------------------------ocr_text场景2
			echo "请输入ocr_text服务在管理后台中的service code"
			read -e ocr_text_service_code
			input_mk_sure ocr_text_service_code
		fi
		echo "orc_text服务配置完成。"
		echo ""
	else
		ocr_text_need=no
	fi

	#ocr_barcode
	echo "是否需要部署ocr_barcode服务?(y/n)"
	yes_or_no
	if [ "$?" -eq 1 ];then
		ocr_barcode_need=yes
		#配置ocr_barcode服务
		echo "开始配置ocr_barcode服务..."
		if [ "$scene" -eq 1 ];then
	#---------------------------------------------------------------------------------------------------------ocr_barcode场景1
			#线程池中的线程数目
			echo "请输入启动线程数(根据并发处理情况输入，如128)"
			read -e ocr_barcode_thread_num
			input_mk_sure ocr_barcode_thread_num
		else
	#-----------------------------------------------------------------------------------------------------------ocr_barcode场景2
			echo "请输入ocr_barcode服务在管理后台中的service code"
			read -e ocr_barcode_service_code
			input_mk_sure ocr_barcode_service_code
		fi
		echo "orc_barcode服务配置完成。"
		echo ""
	else
		ocr_barcode_need=no
	fi

	#hwr
	echo "是否需要部署hwr服务?(y/n)"
	yes_or_no
	if [ "$?" -eq 1 ];then
		hwr_need=yes
		#配置hwr服务
		echo "开始配置hwr服务..."
		if [ "$scene" -eq 1 ];then
	#---------------------------------------------------------------------------------------------------------hwr场景1
			#线程池中的线程数目
			echo "请输入启动线程数(根据并发处理情况输入，如128)"
			read -e hwr_thread_num
			input_mk_sure hwr_thread_num
		else
	#-----------------------------------------------------------------------------------------------------------hwr场景2
			echo "请输入hwr服务在管理后台中的service code"
			read -e hwr_service_code
			input_mk_sure hwr_service_code
		fi
		echo "hwr服务配置完成。"
		echo ""
	else
		hwr_need=no
	fi

	#mt
	echo "是否需要部署mt服务?(y/n)"
	yes_or_no
	if [ "$?" -eq 1 ];then
		mt_need=yes
		#配置mt服务
		echo "开始配置mt服务..."
		if [ "$scene" -eq 1 ];then
	#---------------------------------------------------------------------------------------------------------mt场景1
			#线程池中的线程数目
			echo "请输入启动线程数（根据并发处理情况输入，如32）"
			read -e mt_thread_num
			input_mk_sure mt_thread_num
		else
	#---------------------------------------------------------------------------------------------------------mt场景2
			echo "请输入mt服务在管理后台中的service code"
			read -e mt_service_code
			input_mk_sure mt_service_code
		fi
		echo "mt服务配置完成。"
		echo ""
	else
		mt_need=no
	fi

    #text_analyze
    echo "是否需要部署text_analyze服务?(y/n)"
    yes_or_no
    if [ "$?" -eq 1 ];then
        text_analyze_need=yes
        #配置text_analyze服务
        echo "开始配置text_analyze服务..."
        if [ "$scene" -eq 1 ];then
    #---------------------------------------------------------------------------------------------------------text_analyze场景1
            #线程池中的线程数目
            echo "请输入本服务的启动线程数(根据并发处理情况输入，如4)"
            read -e text_analyze_thread_num
            input_mk_sure text_analyze_thread_num
        else
    #---------------------------------------------------------------------------------------------------------text_analyze场景2
	        echo "请输入text_analyze服务在管理后台中的service code"
            read -e text_analyze_service_code
            input_mk_sure text_analyze_service_code
        fi
        echo "text_analyze服务配置完成。"
        echo ""
    else
        text_analyze_need=no
    fi

	#ta_sync 默认如果选择了text_analyze服务, 则需要配置ta_sync服务
	#echo "是否需要部署ta_sync服务?(y or n)"
	#yes_or_no
	#if [ "$?" -eq 1 ];then
	if [ "$text_analyze_need"X = "yes"X ]; then
		ta_sync_need=yes
		#配置ta_sync服务
		echo "开始配置ta_sync服务..."
		#---------------------------------------------------------------------------------------------------------nlu_sync场景1
		if [ "$scene" -eq 1 ];then
			#线程池中的线程数目
			echo "请输入启动线程数(根据并发处理情况输入，如24)"
			read -e ta_sync_thread_num
			input_mk_sure ta_sync_thread_num
			
			#配置nlu服务列表
			echo "请输入text_analyze服务列表，(格式：10.0.1.100:29000;10.0.1.101:29000)"
			read -e ta_server_list
			input_mk_sure ta_server_list		
		else
		#---------------------------------------------------------------------------------------------------------nlu_sync场景2
			echo "请输入ta_sync服务在管理后台中的service code"
			read -e ta_sync_service_code
			input_mk_sure ta_sync_service_code
		fi
		echo "ta_sync服务配置完成。"
		echo ""
	else
		ta_sync_need=no
	fi

    #tts
	echo "是否需要部署tts服务?(y/n)"
	yes_or_no
	if [ "$?" -eq 1 ];then
		tts_need=yes
		#配置tts服务
		echo "开始配置tts服务..."
		if [ "$scene" -eq 1 ];then
	#---------------------------------------------------------------------------------------------------------tts场景1
			#线程池中的线程数目
			echo "请输入本服务的启动线程数(根据并发处理情况输入，如128)"
			read -e tts_thread_num
			input_mk_sure tts_thread_num
		else
	#---------------------------------------------------------------------------------------------------------tts场景2
			echo "请输入tts服务在管理后台中的service code"
			read -e tts_service_code
			input_mk_sure tts_service_code
		fi
		echo "tts服务配置完成。"
		echo ""
	else
		tts_need=no
	fi
else
	echo "非交互安装模式"
	echo "请保证脚本顶部的基础配置已配置好，这些配置将用作服务配置。"
fi #interactice

#############################################
##	检查文件
#############################################
echo "------------------开始检测文件是否存在------------------------"

#公共模块安装包检测
if_file_exist cloud_debug_common.tar.gz
if [ $? -ne 1 ];then
	echo "cloud_debugcommon.tar.gz is not exist"
	exit 0
fi

#asr nlu能力模块包检测
if [ "$asr_need"X = "yes"X -o "$nlu_need"X = "yes"X ]; then
        if_file_exist cloud_debug_asr_and_nlu.tar.gz
        if [ $? -ne 1 ];then
                echo "cloud_debug_asr_and_nlu.tar.gz is not exist"
                exit 0
        fi
fi

# ocr_bizcard能力模块包检测
if [ "$ocr_bizcard_need"X = "yes"X ];then
	if_file_exist cloud_debug_ocr_bizcard.tar.gz
	if [ $? -ne 1 ];then 
		echo "cloud_debug_ocr_bizcard.tar.gz is not exist"
		exit 0
	fi
fi

# hwr能力模块包检测
if [ "$hwr_need"X = "yes"X ];then
	if_file_exist cloud_debug_hwr.tar.gz
	if [ $? -ne 1 ];then
		echo "cloud_debug_hwr.tar.gz is not exist"
		exit 0
	fi
fi

# mt能力模块包检测
if [ "$mt_need"X = "yes"X ];then
	if_file_exist cloud_debug_mt.tar.gz
	if [ $? -ne 1 ];then
		echo "cloud_debug_mt.tar.gz is not exist"
		exit 0
	fi
fi

#TODO 各个能力模块在此处增加能力包解压过程 能力包中包括各个能力自身的配置文件

echo "------------------文件检测完成-------------------------------"


#############################################
##	检查环境
#############################################

echo "------------------开始检测环境-------------------------------"

#新版nlu7.6引擎已经不再依赖jvm
#nlu要求安装jdk 
#if [ "$nlu_need"X = "yes"X ]; then
#	if [ "$JAVA_HOME"X = X ]; then
#		echo "JAVA_HOME环境变量不存在，请正确安装jdk，设置JAVA_HOME环境变量。"
#		exit 0
#	fi
#fi


echo "------------------检测环境完成-------------------------------"



#############################################
##	部署文件
#############################################

echo "将会安装到${HOME}/cloud"

#---------------------------------------------------------------
#直接安装到默认目录下，暂不提供指定路径安装
#echo "是否需要安装到指定路径下,默认路径为${HOME}/cloud(y/n)"
#yes_or_no
#if [ "$?" -eq 1 ];then
#自定义安装目录
#echo "请输入指定的安装目录(绝对路径)"
#read personal_dir
#input_mk_sure 16 $personal_dir
#检测自定义目录是否存在
#if [ -d $personal_dir ];then
#	echo "自定义安装目录为:$personal_dir"
#else
#	#不存在此目录,则给出提示
#	echo "$personal_dir 不存在，请确认是否存在或者手动建立。"
#	exit 0
#fi
#fi
#-------------------------------------------------------------------

echo "-------------------开始部署文件------------------------------"
mkdir ${HOME}/deploy
if [ "$?" -ne 0 -a "$?" -ne 1 ];then
	exit 0
fi

mkdir ${HOME}/deploy/cloud
if [ "$?" -ne 0 -a "$?" -ne 1 ];then
	exit 0
fi


# ocr_bizcard能力模块安装包
if [ "$ocr_bizcard_need"X = "yes"X ];then
	cp cloud_debug_ocr_bizcard.tar.gz ${HOME}/deploy/
	if [ "$?" -ne 0 ];then
		exit 0
	fi

	tar -zxvf ${HOME}/deploy/cloud_debug_ocr_bizcard.tar.gz -C ${HOME}/deploy/cloud
	if [ "$?" -ne 0 ];then
		exit 0
	fi
fi

# hwr能力模块安装包
if [ "$hwr_need"X = "yes"X ];then
	cp cloud_debug_hwr.tar.gz ${HOME}/deploy/
	if [ "$?" -ne 0 ];then
		exit 0
	fi

	tar -zxvf ${HOME}/deploy/cloud_debug_hwr.tar.gz -C ${HOME}/deploy/cloud
	if [ "$?" -ne 0 ];then
		exit 0
	fi
fi

# mt能力模块安装包
if [ "$mt_need"X = "yes"X ];then
	cp cloud_debug_mt.tar.gz ${HOME}/deploy/
	if [ "$?" -ne 0 ];then
		exit 0
	fi

	tar -zxvf ${HOME}/deploy/cloud_debug_mt.tar.gz -C ${HOME}/deploy/cloud
	if [ "$?" -ne 0 ];then
		exit 0
	fi
fi

# asr nlu能力模块安装包
if [ "$asr_need"X = "yes"X -o "$nlu_need"X = "yes"X ]; then
	cp cloud_debug_asr_and_nlu.tar.gz ${HOME}/deploy/
	if [ "$?" -ne 0 ];then
		exit 0
	fi
	
	tar -xzvf ${HOME}/deploy/cloud_debug_asr_and_nlu.tar.gz -C ${HOME}/deploy/cloud
	if [ "$?" -ne 0 ];then
		exit 0
	fi
fi

if [ "$text_analyze_need"X = "yes"X ]; then
	cp cloud_debug_ta.tar.gz ${HOME}/deploy/
	if [ "$?" -ne 0 ]; then
		exit 0
	fi	

	tar -xzvf ${HOME}/deploy/cloud_debug_ta.tar.gz -C ${HOME}/deploy/cloud
	if [ "$?" -ne 0 ]; then
		exit 0
	fi
fi

#公共模块安装包
cp cloud_debug_common.tar.gz ${HOME}/deploy/
if [ "$?" -ne 0 ];then
    exit 0
fi

tar -xzvf ${HOME}/deploy/cloud_debug_common.tar.gz -C ${HOME}/deploy/cloud
if [ "$?" -ne 0 ];then
        exit 0
fi

echo "正在拷贝服务文件..."
rm -rf ${HOME}/cloud
mv -f ${HOME}/deploy/cloud ${HOME}/
if [ "$?" -ne 0 ];then
        exit 0
fi

mkdir -p ${HOME}/cloud/data

#chmod +x ${HOME}/cloud/bin/servicefx*
find ${HOME}/cloud/ -name servicefx* -type f | xargs chmod +x

#需要root用户去操作
#cp ${HOME}/cloud/conf/ft.rules /etc/udev/rules.d/

echo "-------------------文件部署完毕------------------------------"


#############################################
##	配置环境变量
#############################################

echo "-------------------开始配置环境变量--------------------------"
cd ${HOME}/cloud/shell
sh install.sh
if [ "$?" -ne 0 ];then
        exit 0
fi
echo "-------------------环境变量配置完毕---------------------------"


#############################################
##	根据配置修改服务
#############################################
echo "-------------------开始修改服务--------------------------------"

#----------------------------------------------------------------------------------------------------修改全局通用配置项-场景1
if [ "$scene" -eq 1 ];then
    #更改场景配置
    sed -i -e "s/^PRIVATE_CLOUD_VERSION=.*$/PRIVATE_CLOUD_VERSION=SERVER/g" $global_generic_config_path
    sed -i -e "s/^use_admin_sys=.*$/use_admin_sys=no/g" $global_generic_config_path
    #修改领域
    sed -i -e "s/^domain_code=.*$/domain_code=$domain_code/g" $global_generic_config_path

    #修改server_sense
    sed -i -e "s/^server_sense=.*$/server_sense=$server_sense/g" $global_generic_config_path
        
    #修改zookeeper_server
    sed -i -e "s/^zookeeper_server=.*$/zookeeper_server=$zookeeper_server/g" $global_generic_config_path

    #use_slb
    sed -i -e "s/^use_slb=.*$/use_slb=$use_slb/g" $request_config_path
else
#----------------------------------------------------------------------------------------------------修改全局通用配置项-场景2
    #更改场景配置
    sed -i -e "s/^PRIVATE_CLOUD_VERSION=.*$/PRIVATE_CLOUD_VERSION=PLATFORM/g" $global_generic_config_path
    sed -i -e "s/^use_admin_sys=.*$/use_admin_sys=yes/g" $global_generic_config_path
    sed -i -e "s|^admin_sys_url=.*$|admin_sys_url=http://$manager_ip:$manager_port/hcicpmProtocol/interface|g" $global_generic_config_path
    sed -i -e "s/^cloud_flag=.*$/cloud_flag=$cloud_flag/g" $global_generic_config_path
    sed -i -e "s/^tx_cloud_url=.*$/tx_cloud_url=$tx_cloud_url/g" $global_generic_config_path
    #修改领域
    sed -i -e "s/^domain_code=.*$/domain_code=$domain_code/g" $global_generic_config_path

    #修改server_sense
    sed -i -e "s/^server_sense=.*$/server_sense=$server_sense/g" $global_generic_config_path
        
    #修改zookeeper_server
    sed -i -e "s/^zookeeper_server=.*$/zookeeper_server=$zookeeper_server/g" $global_generic_config_path

    #use_slb
    sed -i -e "s/^use_slb=.*$/use_slb=$use_slb/g" $request_config_path
fi


#license_server
if [ "$license_server_need"X == "yes"X ];then
#-------------------------------------------------------------------------------------------------------license server场景1
	#配置license_server服务
	echo "开始修改license_server服务配置..."
	if [ "$scene" -eq 1 ];then
		#线程池中的线程数目
		sed -i -e "s/^threads_num=.*$/threads_num=$license_server_thread_num/g" $license_server_config_path
	
		#修改其中的ip地址
		sed -i -e "s/^ip=.*$/ip=$server_ip:20050/g" $license_server_config_path
		sed -i -e "s/^module_info_ip=.*$/module_info_ip=$server_ip:20051/g" $license_server_config_path

		#授权模式,0:硬授权,1:软授权
		sed -i -e "s/^license_mode=.*$/license_mode=$license_server_mode/g" $license_server_config_path

		#修改授权服务器的权重信息
		sed -i -e "s/^priority=.*$/priority=$license_server_priority/g" $license_server_config_path
	else
#--------------------------------------------------------------------------------------------------------license server场景2
		#管理后台中的service code
		sed -i -e "s/^id=.*$/id=$license_server_service_code/g" $license_server_config_path
	fi
fi


#本地控制服务local_control
if [ "$local_control_need"X == "yes"X ];then
#-------------------------------------------------------------------------------------------------------local control场景1
    #配置local_control服务
    echo "开始修改local_control服务配置..."
    #if [ "$scene" -eq 1 ];then
		#线程池中的线程数目
        sed -i -e "s/^threads_num=.*$/threads_num=$local_control_thread_num/g" $local_control_config_path
    
        #修改其中的ip地址
        sed -i -e "s/^ip=.*$/ip=$server_ip:15000/g" $local_control_config_path
        sed -i -e "s/^module_info_ip=.*$/module_info_ip=$server_ip:15001/g" $local_control_config_path

		#修改接收控制命令的端口
		sed -i -e "s/^http_server_port=.*$/http_server_port=$local_control_cmd_port/g" $local_control_config_path

    #else 
#--------------------------------------------------------------------------------------------------------local control场景2	
        #管理后台中的service code
        sed -i -e "s/^id=.*$/id=$local_control_service_code/g" $local_control_config_path
    #fi
fi


#td调度的相关配置信息
if [ "$td_need"X == "yes"X ];then
	#需要对调度服务进行部署
	echo "开始修改调度模块配置..."
	#if [ "$scene" -eq 1 ];then
#-------------------------------------------------------------------------------------------------td场景1
				
		#更改request_ip
		sed -i -e "s/^ip=.*$/ip=$server_ip:0/g" $request_config_path

		#更改app_key & dev_key
		sed -i -e "s/app_key/$app_key/g" $request_config_path
		sed -i -e "s/^developer_key=.*$/developer_key=$dev_key/g" $request_config_path

		#修改socket服务的appkey
		sed -i -e "s/app_key=.*$/app_key=$app_key/g" $socket_config_path
		sed -i -e "s/^developer_key=.*$/developer_key=$dev_key/g" $socket_config_path

		#修改mrcp服务的appkey
		sed -i -e "s/app_key=.*$/app_key=$app_key/g" $mrcp_config_path
		sed -i -e "s/^developer_key=.*$/developer_key=$dev_key/g" $mrcp_config_path
			
		#更改redis的相关服务
		sed -i -e "s/^redis=.*$/redis=$redis_ip:$redis_port/g" $request_config_path
		#修改认证密码
		sed -i -e "s/^redis_auth=.*$/redis_auth=$redis_auth/g" $request_config_path
		
	#else
#---------------------------------------------------------------------------------------------------td场景2
		
	    #在管理后台中的service code
        sed -i -e "s/^id=.*$/id=$td_service_code/g" $request_config_path
	#fi
fi


#http server 接口
if [ "$http_need"X == "yes"X ];then
    echo "开始修改http服务配置"
    #if [ "$scene" -eq 1 ];then
#---------------------------------------------------------------------------------------------------http server场景1

		#修改ip及module_info_ip
		sed -i -e "s/^ip=.*$/ip=$server_ip:14000/g" $http_config_path
		sed -i -e "s/^module_info_ip=.*$/module_info_ip=$server_ip:14001/g" $http_config_path

		#线程池中的线程数目
        sed -i -e "s/^threads_num=.*$/threads_num=$http_thread_num/g" $http_config_path

		#修改授权处理信息
		sed -i -e "s/^http_access_server_thread_nums=.*$/http_access_server_thread_nums=$http_access_thread_num/g" $http_config_path
		sed -i -e "s/^http_access_server_port=.*$/http_access_server_port=$http_access_port/g" $http_config_path

		#修改识别处理信息
		sed -i -e "s/^http_request_server_thread_nums=.*$/http_request_server_thread_nums=$http_request_thread_num/g" $http_config_path
		sed -i -e "s/^http_request_server_port=.*$/http_request_server_port=$http_request_port/g" $http_config_path

    #else
#---------------------------------------------------------------------------------------------------http server场景2

        #在管理后台中的service code
        sed -i -e "s/^id=.*$/id=$http_service_code/g" $http_config_path
    #fi
fi


#socket server 接口
if [ "$socket_need"X == "yes"X ];then
    echo "开始修改socket接口配置"
    if [ "$scene" -eq 1 ];then
#---------------------------------------------------------------------------------------------------socket server场景1

		#修改ip信息
		sed -i -e "s/^ip=.*$/ip=$server_ip:12000/g" $socket_config_path
        sed -i -e "s/^module_info_ip=.*$/module_info_ip=$server_ip:12001/g" $socket_config_path
		
		#启动线程数
		sed -i -e "s/^threads_num=.*$/threads_num=$socket_thread_num/g" $socket_config_path
    else
#---------------------------------------------------------------------------------------------------socket server场景2
		
        #在管理后台中的service code
        sed -i -e "s/^id=.*$/id=$socket_service_code/g" $socket_config_path
    fi
fi 

#mrcp server 接口
if [ "$mrcp_need"X == "yes"X ];then
    echo "开始修改mrcp接口配置"
    if [ "$scene" -eq 1 ];then
#---------------------------------------------------------------------------------------------------mrcp server场景1		

        #修改ip信息
        sed -i -e "s/^ip=.*$/ip=$server_ip:16000/g" $mrcp_config_path
        sed -i -e "s/^module_info_ip=.*$/module_info_ip=$server_ip:16001/g" $mrcp_config_path

        #启动线程数
        sed -i -e "s/^threads_num=.*$/threads_num=$mrcp_thread_num/g" $mrcp_config_path

		#sip端口号，建议为5060
		sed -i -e "s/^sip_port=.*$/sip_port=$mrcp_sip_port/g" $mrcp_config_path

		#mrcp端口号，建议为1644
		sed -i -e "s/^mrcp_port=.*$/mrcp_port=$mrcp_port/g" $mrcp_config_path

        #MRCP服务器所提供的资源（asr;tts;vpr),目前仅支持asr和vpr
		sed -i -e "s/^mrcp_resources=.*$/mrcp_resources=$mrcp_resources/g" $mrcp_config_path
		
    else
#---------------------------------------------------------------------------------------------------mrcp server场景2
		
        #在管理后台中的service code
        sed -i -e "s/^id=.*$/id=$mrcp_service_code/g" $mrcp_config_path
    fi
fi


#开始配置负载服务
if [ "$slb_need"X == "yes"X ];then
	echo "使用负载服务,开始修改slb配置..."
	#if [ "$scene" -eq 1 ];then
#---------------------------------------------------------------------------------------------------slb场景1
		
		#修改监听Ip及moduleInfo的ip地址
		sed -i -e "s/^ip=.*$/ip=$server_ip:10000/g" $slb_config_path
		sed -i -e "s/^module_info_ip=.*$/module_info_ip=$server_ip:10001/g" $slb_config_path
			
		#线程池中的线程数目
                sed -i -e "s/^threads_num=.*$/threads_num=$slb_thread_num/g" $slb_config_path

		#负载策略的选择	1:各个能力服务器轮询,2:根据cpu空闲情况选择(需要本地控制服务的支持)"
		sed -i -e "s/^load_policy=.*$/load_policy=$slb_load_policy/g" $slb_config_path

	#else
#---------------------------------------------------------------------------------------------------slb场景2
		
        #在管理后台中的service code
        sed -i -e "s/^id=.*$/id=$slb_service_code/g" $slb_config_path
	#fi
fi


#部署各个能力

#nlu
if [ "$nlu_need"X == "yes"X ];then
	#配置nlu服务
	echo "开始修改nlu服务配置..."
	#---------------------------------------------------------------------------------------------------------nlu场景1
	#if [ "$scene" -eq 1 ];then
		
		#线程池中的线程数目
                sed -i -e "s/^threads_num=.*$/threads_num=$nlu_thread_num/g" $nlu_config_path
		
		#dialog线程数目
                sed -i -e "s/^dialog_threads_num=.*$/dialog_threads_num=$nlu_dialog_threads_num/g" $nlu_config_path
		
		#content线程数目
                sed -i -e "s/^content_threads_num=.*$/content_threads_num=$nlu_content_threads_num/g" $nlu_config_path
		
		#同步和训练异步处理的线程数目
                sed -i -e "s/^async_threads_num=.*$/async_threads_num=$nlu_async_threads_num/g" $nlu_config_path
		
                #配置redis，用于缓存context信息
                sed -i -e "s/^redis=.*$/redis=$redis_ip:$redis_port/g" $nlu_config_path
                #修改认证密码
                sed -i -e "s/^redis_auth=.*$/redis_auth=$redis_auth/g" $nlu_config_path

		#修改其中的ip地址
		sed -i -e "s/^ip=.*$/ip=$server_ip:17000/g" $nlu_config_path
		sed -i -e "s/^module_info_ip=.*$/module_info_ip=$server_ip:17001/g" $nlu_config_path
        
		#修改request.conf中的IP配置(不使用slb时，用于指定nlu_ip)
                sed -i -e "s/^nlu_ip=.*$/nlu_ip=$server_ip/g" $request_config_path

                #修改ContentQueryUrl
		sed -i -e "s|^ContentQueryUrl=.*$|ContentQueryUrl=$nlu_ContentQueryUrl|g" $nlu_config_path
	#else
	#---------------------------------------------------------------------------------------------------------nlu场景2
		
                #在管理后台中的service code
                sed -i -e "s/^id=.*$/id=$nlu_service_code/g" $nlu_config_path

		#修改request.conf中的IP配置(不使用slb时，用于指定cu的ip)
                sed -i -e "s/^nlu_ip=.*$/nlu_ip=$server_ip/g" $request_config_path		
	#fi
fi


#nlu_sync
if [ "$nlu_sync_need"X == "yes"X ];then
	#配置nlu_sync服务
	echo "开始修改nlu_sync服务配置..."
	#---------------------------------------------------------------------------------------------------------nlu_sync场景1
	#if [ "$scene" -eq 1 ];then
		
		#线程池中的线程数目
                sed -i -e "s/^threads_num=.*$/threads_num=$nlu_sync_thread_num/g" $nlu_sync_config_path
		
		#修改其中的ip地址
		sed -i -e "s/^ip=.*$/ip=$server_ip:18000/g" $nlu_sync_config_path
		sed -i -e "s/^module_info_ip=.*$/module_info_ip=$server_ip:18001/g" $nlu_sync_config_path
		
                #修改request.conf中的IP配置(不使用slb时，用于指定cu的ip)
                sed -i -e "s/^nlu_sync_ip=.*$/nlu_sync_ip=$server_ip/g" $request_config_path
        
                #配置nlu服务列表,如10.0.1.100:17000;10.0.1.101:17000"
		sed -i -e "s/^nlu_server_list=.*$/nlu_server_list=$nlu_server_list/g" $nlu_sync_config_path
        
	#else
	#---------------------------------------------------------------------------------------------------------nlu_sync场景2
		
		#在管理后台中的service code
                sed -i -e "s/^id=.*$/id=$nlu_sync_service_code/g" $nlu_sync_config_path

                #修改request.conf中的IP配置(不使用slb时，用于指定cu的ip)
                sed -i -e "s/^nlu_sync_ip=.*$/nlu_sync_ip=$server_ip/g" $request_config_path
	#fi
fi


#asr_cp
if [ "$asr_need"X == "yes"X ];then
    #配置asr_cp服务
    echo "开修改始asr_cp服务配置..."
    #if [ "$scene" -eq 1 ];then
#---------------------------------------------------------------------------------------------------------asr_cp场景1
		#线程池中的线程数目
                sed -i -e "s/^threads_num=.*$/threads_num=$asr_thread_num/g" $asr_cp_config_path
                sed -i -e "s/^session_count=.*$/session_count=$asr_thread_num/g" $asr_cp_config_path
   
                #修改其中的ip地址
                sed -i -e "s/^ip=.*$/ip=$server_ip:13000/g" $asr_cp_config_path
                sed -i -e "s/^module_info_ip=.*$/module_info_ip=$server_ip:13001/g" $asr_cp_config_path
		
                #修改request.conf中的IP配置(不使用slb时，用于指定cu的ip)
                sed -i -e "s/^asr_cp_ip=.*$/asr_cp_ip=$server_ip/g" $request_config_path
        
		#设置是否支持流转
		sed -i -e "s/^post_process=.*$/post_process=$asr_post_process/g" $asr_cp_config_path
		#设置broker地址
		sed -i -e "s|^broker_addr=.*$|broker_addr=$asr_broker_addr|g" $asr_cp_config_path 
        
    #else
#-----------------------------------------------------------------------------------------------------------asr_cp场景2
		
                #在管理后台中的service code
                sed -i -e "s/^id=.*$/id=$asr_service_code/g" $asr_cp_config_path

                #修改request.conf中的IP配置(不使用slb时，用于指定cu的ip)
                sed -i -e "s/^asr_cp_ip=.*$/asr_cp_ip=$server_ip/g" $request_config_path
    #fi
fi

#asr_dialog
if [ "$asr_dialog_need"X == "yes"X ];then
    #配置asr_dialog服务
    echo "开修改始asr_dialog服务配置..."
    #if [ "$scene" -eq 1 ];then
#---------------------------------------------------------------------------------------------------------asr_dialog场景1
		
		#线程池中的线程数目
                sed -i -e "s/^threads_num=.*$/threads_num=$asr_dialog_thread_num/g" $asr_dialog_config_path
   
                #配置redis，用于缓存context信息
                sed -i -e "s/^redis=.*$/redis=$redis_ip:$redis_port/g" $asr_dialog_config_path
                #修改认证密码
                sed -i -e "s/^redis_auth=.*$/redis_auth=$redis_auth/g" $asr_dialog_config_path

                #修改其中的ip地址
                sed -i -e "s/^ip=.*$/ip=$server_ip:32000/g" $asr_dialog_config_path
                sed -i -e "s/^module_info_ip=.*$/module_info_ip=$server_ip:32001/g" $asr_dialog_config_path
		
                #修改request.conf中的IP配置(不使用slb时，用于指定cu的ip)
                #sed -i -e "s/^asr_dialog_ip=.*$/asr_dialog_ip=$server_ip/g" $request_config_path
        
    #else
#-----------------------------------------------------------------------------------------------------------asr_dialog场景2
		
                #在管理后台中的service code
                sed -i -e "s/^id=.*$/id=$asr_dialog_service_code/g" $asr_dialog_config_path

                #修改request.conf中的IP配置(不使用slb时，用于指定cu的ip)
                #sed -i -e "s/^asr_dialog_ip=.*$/asr_dialog_ip=$server_ip/g" $request_config_path
    #fi
fi

#vpr
if [ "$vpr_need"X == "yes"X ];then
    #配置vpr服务
    echo "开始修改vpr服务配置..."
    if [ "$scene" -eq 1 ];then
#---------------------------------------------------------------------------------------------------------vpr场景1
   
		#线程池中的线程数目
                sed -i -e "s/^threads_num=.*$/threads_num=$vpr_thread_num/g" $vpr_config_path
		
                #修改其中的ip地址
                sed -i -e "s/^ip=.*$/ip=$server_ip:19000/g" $vpr_config_path
                sed -i -e "s/^module_info_ip=.*$/module_info_ip=$server_ip:19001/g" $vpr_config_path

                #修改request.conf中的IP配置(不使用slb时，用于指定cu的ip)
                sed -i -e "s/^vpr_ip=.*$/vpr_ip=$server_ip/g" $request_config_path
  
		#修改模型管理url配置(mongodb)
		sed -i -e "s|^bio_db_conn_str=.*$|bio_db_conn_str=$bio_db_conn_str|g" $vpr_config_path
		
		#修改多选一识别,启动多线处理的模型规模的阈值
		sed -i -e "s|^models_num_threshold_for_1vsN=.*$|models_num_threshold_for_1vsN=$vpr_models_num_threshold_for_1vsN|g" $vpr_config_path
		#修改多选一识别,启动多线处理的线程数
		sed -i -e "s|^threads_num_for_1vsN=.*$|threads_num_for_1vsN=$vpr_threads_num_for_1vsN|g" $vpr_config_path

		#修改模型同步服务地址
		sed -i -e "s/^model_sync_server=.*$/model_sync_server=$server_ip:28000/g" $vpr_config_path

    else
#-----------------------------------------------------------------------------------------------------------vpr场景2
		
                #在管理后台中的service code
                sed -i -e "s/^id=.*$/id=$vpr_service_code/g" $vpr_config_path

                #修改request.conf中的IP配置(不使用slb时，用于指定cu的ip)
                sed -i -e "s/^vpr_ip=.*$/vpr_ip=$server_ip/g" $request_config_path
    fi
fi

#fpr
if [ "$fpr_need"X == "yes"X ];then
    #配置fpr服务
    echo "开始修改fpr服务配置..."
    if [ "$scene" -eq 1 ];then
#---------------------------------------------------------------------------------------------------------fpr场景1
   
		#线程池中的线程数目
                sed -i -e "s/^threads_num=.*$/threads_num=$fpr_thread_num/g" $fpr_config_path
		
                #修改其中的ip地址
                sed -i -e "s/^ip=.*$/ip=$server_ip:20000/g" $fpr_config_path
                sed -i -e "s/^module_info_ip=.*$/module_info_ip=$server_ip:20001/g" $fpr_config_path
		
                #修改request.conf中的IP配置
                sed -i -e "s/^fpr_ip=.*$/fpr_ip=$server_ip/g" $request_config_path

		#修改多选一识别,启动多线处理的模型规模的阈值
		sed -i -e "s|^models_num_threshold_for_1vsN=.*$|models_num_threshold_for_1vsN=$fpr_models_num_threshold_for_1vsN|g" $fpr_config_path
		#修改多选一识别,启动多线处理的线程数
		sed -i -e "s|^threads_num_for_1vsN=.*$|threads_num_for_1vsN=$fpr_threads_num_for_1vsN|g" $fpr_config_path

		#修改模型管理url配置(mongodb)
		sed -i -e "s|^bio_db_conn_str=.*$|bio_db_conn_str=$bio_db_conn_str|g" $fpr_config_path
		
		#修改模型同步服务地址
		sed -i -e "s/^model_sync_server=.*$/model_sync_server=$server_ip:28000/g" $fpr_config_path

    else
#-----------------------------------------------------------------------------------------------------------fpr场景2
        
		#在管理后台中的service code
                sed -i -e "s/^id=.*$/id=$fpr_service_code/g" $fpr_config_path

                #修改request.conf中的IP配置
                sed -i -e "s/^fpr_ip=.*$/fpr_ip=$server_ip/g" $request_config_path
    fi
fi

#afr
if [ "$afr_need"X == "yes"X ];then
    #配置afr服务
    echo "开始修改afr服务配置..."
    if [ "$scene" -eq 1 ];then
#---------------------------------------------------------------------------------------------------------afr场景1
		
		#线程池中的线程数目
                sed -i -e "s/^threads_num=.*$/threads_num=$afr_thread_num/g" $afr_config_path
   
                #修改其中的ip地址
                sed -i -e "s/^ip=.*$/ip=$server_ip:21000/g" $afr_config_path
                sed -i -e "s/^module_info_ip=.*$/module_info_ip=$server_ip:21001/g" $afr_config_path
		
                #修改request.conf中的IP配置
                sed -i -e "s/^afr_ip=.*$/afr_ip=$server_ip/g" $request_config_path
            
		#修改模型管理url配置(mongodb)
		sed -i -e "s|^bio_db_conn_str=.*$|bio_db_conn_str=$bio_db_conn_str|g" $afr_config_path

		#修改多选一识别,启动多线处理的模型规模的阈值
		sed -i -e "s|^models_num_threshold_for_1vsN=.*$|models_num_threshold_for_1vsN=$afr_models_num_threshold_for_1vsN|g" $afr_config_path
		#修改多选一识别,启动多线处理的线程数
		sed -i -e "s|^threads_num_for_1vsN=.*$|threads_num_for_1vsN=$afr_threads_num_for_1vsN|g" $afr_config_path

		#配置redis，用于缓存人脸信息
		sed -i -e "s/^redis=.*$/redis=$redis_ip:$redis_port/g" $afr_config_path
		#修改认证密码
		sed -i -e "s/^redis_auth=.*$/redis_auth=$redis_auth/g" $afr_config_path
		
		#修改模型同步服务地址
		sed -i -e "s/^model_sync_server=.*$/model_sync_server=$server_ip:28000/g" $afr_config_path

		
    else
#-----------------------------------------------------------------------------------------------------------afr场景2
        
		#在管理后台中的service code
                sed -i -e "s/^id=.*$/id=$afr_service_code/g" $afr_config_path

                #修改request.conf中的IP配置
                sed -i -e "s/^afr_ip=.*$/afr_ip=$server_ip/g" $request_config_path
    fi
fi


#model_sync
if [ "$model_sync_need"X == "yes"X ];then
    #配置model_sync服务
    echo "开始修改model_sync服务配置..."
    if [ "$scene" -eq 1 ];then
#---------------------------------------------------------------------------------------------------------model_sync 场景1
		
		#线程池中的线程数目
                sed -i -e "s/^threads_num=.*$/threads_num=$model_sync_thread_num/g" $model_sync_config_path
   
                #修改其中的ip地址
                sed -i -e "s/^ip=.*$/ip=$server_ip:28000/g" $model_sync_config_path
                sed -i -e "s/^module_info_ip=.*$/module_info_ip=$server_ip:28001/g" $model_sync_config_path
		
                #修改request.conf中的IP配置
                sed -i -e "s/^model_sync_ip=.*$/model_sync_ip=$server_ip/g" $request_config_path

                #修改fpr,afr,vpr server_list地址
                sed -i -e "s/^vpr_server_list=.*$/vpr_server_list=$server_ip:19000/g" $model_sync_config_path
                sed -i -e "s/^fpr_server_list=.*$/fpr_server_list=$server_ip:20000/g" $model_sync_config_path
                sed -i -e "s/^afr_server_list=.*$/afr_server_list=$server_ip:21000/g" $model_sync_config_path

                #修改模型管理url配置(mongodb)
                sed -i -e "s|^bio_db_conn_str=.*$|bio_db_conn_str=$bio_db_conn_str|g" $model_sync_config_path

    else
#-----------------------------------------------------------------------------------------------------------model_sync 场景2

                #修改request.conf中的IP配置
                sed -i -e "s/^model_sync_ip=.*$/model_sync_ip=$server_ip/g" $request_config_path

                #在管理后台中的service code
                sed -i -e "s/^id=.*$/id=$model_sync_service_code/g" $model_sync_config_path
    fi
fi

#ocr_template
if [ "$ocr_template_need"X == "yes"X ];then
    #配置ocr_template服务
    echo "开始修改ocr_template服务配置..."
    if [ "$scene" -eq 1 ];then
#---------------------------------------------------------------------------------------------------------ocr_template场景1
		
		#线程池中的线程数目
                sed -i -e "s/^threads_num=.*$/threads_num=$ocr_template_thread_num/g" $ocr_template_config_path
   
                #修改其中的ip地址
                sed -i -e "s/^ip=.*$/ip=$server_ip:23000/g" $ocr_template_config_path
                sed -i -e "s/^module_info_ip=.*$/module_info_ip=$server_ip:23001/g" $ocr_template_config_path
		
                #修改request.conf中的IP配置
                sed -i -e "s/^ocr_template_ip=.*$/ocr_template_ip=$server_ip/g" $request_config_path

    else
#-----------------------------------------------------------------------------------------------------------ocr_template场景2
		
                #在管理后台中的service code
                sed -i -e "s/^id=.*$/id=$ocr_template_service_code/g" $ocr_template_config_path

                #修改request.conf中的IP配置
                sed -i -e "s/^ocr_template_ip=.*$/ocr_template_ip=$server_ip/g" $request_config_path
    fi
fi

#ocr_bankcard
if [ "$ocr_bankcard_need"X == "yes"X ];then
    #配置ocr_bankcard服务
    echo "开始修改ocr_bankcard服务配置..."
    if [ "$scene" -eq 1 ];then
#---------------------------------------------------------------------------------------------------------ocr_bankcard场景1
		
		#线程池中的线程数目
                sed -i -e "s/^threads_num=.*$/threads_num=$ocr_bankcard_thread_num/g" $ocr_bankcard_config_path
   
                #修改其中的ip地址
                sed -i -e "s/^ip=.*$/ip=$server_ip:25000/g" $ocr_bankcard_config_path
                sed -i -e "s/^module_info_ip=.*$/module_info_ip=$server_ip:25001/g" $ocr_bankcard_config_path

                #修改request.conf中的IP配置
                sed -i -e "s/^ocr_bankcard_ip=.*$/ocr_bankcard_ip=$server_ip/g" $request_config_path

    else
#-----------------------------------------------------------------------------------------------------------ocr_bankcard场景2
		
                #在管理后台中的service code
                sed -i -e "s/^id=.*$/id=$ocr_bankcard_service_code/g" $ocr_bankcard_config_path

                #修改request.conf中的IP配置
                sed -i -e "s/^ocr_bankcard_ip=.*$/ocr_bankcard_ip=$server_ip/g" $request_config_path
    fi
fi

#ocr_bizcard
if [ "$ocr_bizcard_need"X == "yes"X ];then
    #配置ocr_bizcard服务
    echo "开始修改ocr_bizcard服务配置..."
    if [ "$scene" -eq 1 ];then
#---------------------------------------------------------------------------------------------------------ocr_bizcard场景1
		
		#线程池中的线程数目
                sed -i -e "s/^threads_num=.*$/threads_num=$ocr_bizcard_thread_num/g" $ocr_bizcard_config_path
   
                #修改其中的ip地址
                sed -i -e "s/^ip=.*$/ip=$server_ip:27000/g" $ocr_bizcard_config_path
                sed -i -e "s/^module_info_ip=.*$/module_info_ip=$server_ip:27001/g" $ocr_bizcard_config_path
		
                #修改request.conf中的IP配置
                sed -i -e "s/^ocr_bizcard_ip=.*$/ocr_bizcard_ip=$server_ip/g" $request_config_path

    else
#-----------------------------------------------------------------------------------------------------------ocr_bizcard场景2
		
                #在管理后台中的service code
                sed -i -e "s/^id=.*$/id=$ocr_bizcard_service_code/g" $ocr_bizcard_config_path

                #修改request.conf中的IP配置
                sed -i -e "s/^ocr_bizcard_ip=.*$/ocr_bizcard_ip=$server_ip/g" $request_config_path
    fi
fi

#ocr_text
if [ "$ocr_text_need"X == "yes"X ];then
    #配置ocr_text服务
    echo "开始修改ocr_text服务配置..."
    if [ "$scene" -eq 1 ];then
#---------------------------------------------------------------------------------------------------------ocr_text场景1
		
		#线程池中的线程数目
                sed -i -e "s/^threads_num=.*$/threads_num=$ocr_text_thread_num/g" $ocr_text_config_path
   
                #修改其中的ip地址
                sed -i -e "s/^ip=.*$/ip=$server_ip:26000/g" $ocr_text_config_path
                sed -i -e "s/^module_info_ip=.*$/module_info_ip=$server_ip:26001/g" $ocr_text_config_path

                #修改request.conf中的IP配置
                sed -i -e "s/^ocr_text_ip=.*$/ocr_text_ip=$server_ip/g" $request_config_path

    else
#-----------------------------------------------------------------------------------------------------------ocr_text场景2
       
                #在管理后台中的service code
                sed -i -e "s/^id=.*$/id=$ocr_text_service_code/g" $ocr_text_config_path

                #修改request.conf中的IP配置
                sed -i -e "s/^ocr_text_ip=.*$/ocr_text_ip=$server_ip/g" $request_config_path
    fi
fi

#ocr_barcode
if [ "$ocr_barcode_need"X == "yes"X ];then
    #配置ocr_barcode服务
    echo "开始修改ocr_barcode服务配置..."
    if [ "$scene" -eq 1 ];then
#---------------------------------------------------------------------------------------------------------ocr_barcode场景1
		
		#线程池中的线程数目
                sed -i -e "s/^threads_num=.*$/threads_num=$ocr_barcode_thread_num/g" $ocr_barcode_config_path
   
                #修改其中的ip地址
                sed -i -e "s/^ip=.*$/ip=$server_ip:31000/g" $ocr_barcode_config_path
                sed -i -e "s/^module_info_ip=.*$/module_info_ip=$server_ip:31001/g" $ocr_barcode_config_path

                #修改request.conf中的IP配置
                sed -i -e "s/^ocr_barcode_ip=.*$/ocr_barcode_ip=$server_ip/g" $request_config_path

    else
#-----------------------------------------------------------------------------------------------------------ocr_barcode场景2
     
                #在管理后台中的service code
                sed -i -e "s/^id=.*$/id=$ocr_barcode_service_code/g" $ocr_barcode_config_path

                #修改request.conf中的IP配置
                sed -i -e "s/^ocr_barcode_ip=.*$/ocr_barcode_ip=$server_ip/g" $request_config_path
    fi
fi


#hwr
if [ "$hwr_need"X == "yes"X ];then
    #配置hwr服务
    echo "开始修改hwr服务配置..."
    if [ "$scene" -eq 1 ];then
#---------------------------------------------------------------------------------------------------------hwr场景1
		
		#线程池中的线程数目
                sed -i -e "s/^threads_num=.*$/threads_num=$hwr_thread_num/g" $hwr_config_path
   
                #修改其中的ip地址
                sed -i -e "s/^ip=.*$/ip=$server_ip:30000/g" $hwr_config_path
                sed -i -e "s/^module_info_ip=.*$/module_info_ip=$server_ip:30001/g" $hwr_config_path

                #修改request.conf中的IP配置
                sed -i -e "s/^hwr_ip=.*$/hwr_ip=$server_ip/g" $request_config_path

    else
#-----------------------------------------------------------------------------------------------------------hwr场景2
		
                #在管理后台中的service code
                sed -i -e "s/^id=.*$/id=$hwr_service_code/g" $hwr_config_path

                #修改request.conf中的IP配置
                sed -i -e "s/^hwr_ip=.*$/hwr_ip=$server_ip/g" $request_config_path
    fi
fi

#mt
if [ "$mt_need"X == "yes"X ];then
    #配置mt服务
    echo "开始修改mt服务配置..."
    if [ "$scene" -eq 1 ];then
#---------------------------------------------------------------------------------------------------------mt场景1
		
		#线程池中的线程数目
                sed -i -e "s/^threads_num=.*$/threads_num=$mt_thread_num/g" $mt_config_path
   
                #修改其中的ip地址
                sed -i -e "s/^ip=.*$/ip=$server_ip:34000/g" $mt_config_path
                sed -i -e "s/^module_info_ip=.*$/module_info_ip=$server_ip:34001/g" $mt_config_path

                #修改request.conf中的IP配置
                sed -i -e "s/^mt_ip=.*$/mt_ip=$server_ip/g" $request_config_path

    else
#-----------------------------------------------------------------------------------------------------------mt场景2
		
                #在管理后台中的service code
                sed -i -e "s/^id=.*$/id=$mt_service_code/g" $mt_config_path

                #修改request.conf中的IP配置
                sed -i -e "s/^mt_ip=.*$/mt_ip=$server_ip/g" $request_config_path
    fi
fi

#tts
if [ "$tts_need"X == "yes"X ];then
	#配置tts服务
	echo "开始修改tts服务配置..."
	if [ "$scene" -eq 1 ];then
		
		#线程池中的线程数目
                sed -i -e "s/^threads_num=.*$/threads_num=$tts_thread_num/g" $tts_config_path
	
		#修改其中的ip地址
		sed -i -e "s/^ip=.*$/ip=$server_ip:22000/g" $tts_config_path
                sed -i -e "s/^module_info_ip=.*$/module_info_ip=$server_ip:22001/g" $tts_config_path

                #修改request.conf中的IP配置
                sed -i -e "s/^tts_ip=.*$/tts_ip=$server_ip/g" $request_config_path

	else
		
                #在管理后台中的service code
                sed -i -e "s/^id=.*$/id=$tts_service_code/g" $tts_config_path

                #修改request.conf中的IP配置
                sed -i -e "s/^tts_ip=.*$/tts_ip=$server_ip/g" $request_config_path
	fi
fi

#text_analyze
if [ "$text_analyze_need"X == "yes"X ];then
	#配置text_analyze服务
	echo "开始修改text_analyze服务配置..."
	if [ "$scene" -eq 1 ];then
		
		#线程池中的线程数目
		sed -i -e "s/^threads_num=.*$/threads_num=$text_analyze_thread_num/g" $text_analyze_config_path
	
		#修改其中的ip地址
		sed -i -e "s/^ip=.*$/ip=$server_ip:29000/g" $text_analyze_config_path
		sed -i -e "s/^module_info_ip=.*$/module_info_ip=$server_ip:29001/g" $text_analyze_config_path

		# 修改redis的地址
		sed -i -e "s/^redis=.*$/redis=$redis_ip:$redis_port/g" $text_analyze_config_path
		#修改认证密码
		sed -i -e "s/^redis_auth=.*$/redis_auth=$redis_auth/g" $text_analyze_config_path

		#修改request.conf中的IP配置
		sed -i -e "s/^text_analyze_ip=.*$/text_analyze_ip=$server_ip/g" $request_config_path

	else
		
		#在管理后台中的service code
		sed -i -e "s/^id=.*$/id=$text_analyze_service_code/g" $text_analyze_config_path

		#修改request.conf中的IP配置
		sed -i -e "s/^text_analyze_ip=.*$/text_analyze_ip=$server_ip/g" $request_config_path

	fi
fi

#text_analyze
if [ "$ta_sync_need"X == "yes"X ];then
	#配置text_analyze服务
	echo "开始修改ta_sync服务配置..."
	if [ "$scene" -eq 1 ];then
		
		#线程池中的线程数目
		sed -i -e "s/^threads_num=.*$/threads_num=$ta_sync_thread_num/g" $ta_sync_config_path
	
		#修改其中的ip地址
		sed -i -e "s/^ip=.*$/ip=$server_ip:33000/g" $ta_sync_config_path
		sed -i -e "s/^module_info_ip=.*$/module_info_ip=$server_ip:33001/g" $ta_sync_config_path

		#修改request.conf中的IP配置
		#sed -i -e "s/^ta_sync_ip=.*$/ta_sync_ip=$server_ip/g" $request_config_path

		sed -i -e "s/^ta_server_list=.*$/ta_server_list=$ta_server_list/g" $ta_sync_config_path

	else
		
		#在管理后台中的service code
		sed -i -e "s/^id=.*$/id=$ta_sync_service_code/g" $ta_sync_config_path

		#修改request.conf中的IP配置
		sed -i -e "s/^ta_sync_ip=.*$/ta_sync_ip=$server_ip/g" $request_config_path

	fi
fi


#asr_trans
if [ "$asr_trans_need"X == "yes"X ];then
	#配置asr_trans服务
	echo "开始修改asr_trans服务配置..."
	if [ "$scene" -eq 1 ];then
		
		#线程池中的线程数目
		sed -i -e "s/^threads_num=.*$/threads_num=$asr_trans_thread_num/g" $asr_trans_config_path
	
		#修改其中的ip地址
		sed -i -e "s/^ip=.*$/ip=$server_ip:20006/g" $asr_trans_config_path
        sed -i -e "s/^module_info_ip=.*$/module_info_ip=$server_ip:20016/g" $asr_trans_config_path

        #配置redis，用于缓存context信息
        sed -i -e "s/^redis=.*$/redis=$redis_ip:$redis_port/g" $asr_trans_config_path
        #修改认证密码
        sed -i -e "s/^redis_auth=.*$/redis_auth=$redis_auth/g" $asr_trans_config_path

	else
		
		#在管理后台中的service code
		sed -i -e "s/^id=.*$/id=$asr_trans_service_code/g" $asr_trans_config_path

		#线程池中的线程数目
		sed -i -e "s/^threads_num=.*$/threads_num=$asr_trans_thread_num/g" $asr_trans_config_path
	
		#修改其中的ip地址
		sed -i -e "s/^ip=.*$/ip=$server_ip:20006/g" $asr_trans_config_path
		sed -i -e "s/^module_info_ip=.*$/module_info_ip=$server_ip:20016/g" $asr_trans_config_path

	fi
fi

if [ -z "$personal_dir" -o "$personal_dir"X = "${HOME}"X -o "$personal_dir"X = "${HOME}/"X -o "$personal_dir"X = "${HOME}/cloud"X -o "$personal_dir"X = "${HOME}/cloud/"X  ];then
#为空,没有自定义
	echo "灵云服务已经部署在默认目录下。"
else
	#如果自定义了安装路径，需要更改既有的环境变量
	#1将${HOME}/cloud文件夹移动到/opt下面，并更改权限:chown -R hcicloud:hcicloud  /opt/cloud
	mv ${HOME}/cloud $personal_dir/
	#chown -R hcicloud:hcicloud $personal_dir/cloud
	#2更改hcicloud的环境变量.bash_profile
	sed -i -e "s:export HCICLOUD_HOME=\${HOME}/cloud:export HCICLOUD_HOME=$personal_dir/cloud:g" ${HOME}/.bash_profile
	sed -i -e "s:export JTTS_ROOT=\${HOME}/tts:export JTTS_ROOT=$personal_dir/tts:g" ${HOME}/.bash_profile
	#3更改http配置:编辑/etc/httpd/conf/httpd.conf,将其中的${HOME}更改为/opt
	#sed -i -e "s:${HOME}:$personal_dir:g" /etc/httpd/conf/httpd.conf
	#4:更改/etc/init.d/httpd,将其中的${HOME}更改为/opt。
	#sed -i -e "s:${HOME}:$personal_dir:g" /etc/init.d/httpd
	#5:执行命令
	#rm /etc/httpd/logs
	#ln -s $personal_dir/cloud/log /etc/httpd/logs
	#6:编辑/etc/php.d/request_api_php_ext.ini，将其中的${HOME}更改为/opt
	#sed -i -e "s:${HOME}:$personal_dir:g" /etc/php.d/request_api_php_ext.ini
	#7:修改cloud/con下的request.conf request_log.conf，将其中的${HOME}更改为/opt
	#sed -i -e "s:${HOME}:$personal_dir:g" $personal_dir/cloud/conf/request.conf
	#sed -i -e "s:${HOME}:$personal_dir:g" $personal_dir/cloud/conf/request_log.conf
	#8:更改/etc/ld.so.conf，将其中的${HOME}更改为/opt，然后执行ldconfig命令。
#	sed -i -e "s:${HOME}:$personal_dir:g" /etc/ld.so.conf
#	ldconfig
fi

echo "-------------------服务修改完毕--------------------------------"


#############################################
##	清理资源
#############################################

echo "删除临时工作目录：deploy"
rm -rf ${HOME}/deploy

echo "关闭可能已经存在的服务"

ps -ef |grep servicefx_ |awk '{print $2}' |while read pid
        do
                kill -9 $pid
        done

if [ "$asr_need"X = "yes"X ]; then
    echo "------重要提示:请将asr_cp的模型文件拷贝到res/asr的目录下，然后按说明文档启动相关服务-----------"
fi

if [ "$scene" -eq 1 ];then
	if [ "$vpr_need"X = "yes"X ]; then
		echo "------重要提示 若部署了模型同步服务,请修改$vpr_config_path 中模型同步配置(model_sync_server)-----------"
	fi
	if [ "$afr_need"X = "yes"X ]; then
    	echo "------重要提示 若部署了模型同步服务,请修改$afr_config_path 中模型同步配置(model_sync_server)-----------"
	fi
	if [ "$fpr_need"X = "yes"X ]; then
    	echo "------重要提示 若部署了模型同步服务,请修改$fpr_config_path 中模型同步配置(model_sync_server)-----------"
	fi
	if [ "$model_sync_need"X = "yes"X ]; then
    	echo "------重要提示 请修改$model_sync_config_path 中配置项vpr_server_list,afr_server_list,fpr_server_list-----------"
	fi
fi

echo "install success!"
echo "灵云能力平台安装完成!"
