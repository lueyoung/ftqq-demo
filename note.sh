#!/bin/bash
show_help () {
cat << USAGE
usage: $0 [ -t MSG-TITLE ] [ -c MSG-CONTENT ] [ -k SCKEY-TO-SEND-MSG ]

    -k : Specify the SCKEY of the user to send note to. If multiple, set the keys in term of csv, 
         as 'key-1,key-2,key-3'.
    -t : Specify the title of the message to send.  
    -c : Specify the content of the message. If not specified, send no content.

USAGE
exit 0
}
# Get Opts
while getopts "hk:t:c:" opt; do # 选项后面的冒号表示该选项需要参数
    case "$opt" in
    h)  show_help
        ;;
    k)  SCKEYS=$OPTARG
        ;;
    t)  TITLE=$OPTARG
        ;;
    c)  CONTENT=$OPTARG
        ;;
    ?)  # 当有不认识的选项的时候arg为?
        echo "unkonw argument"
        exit 1
        ;;
    esac
done
chk_var () {
if [ -z "$2" ]; then
  echo "$(date -d today +'%Y-%m-%d %H:%M:%S') - [ERROR] - no input for \"$1\", try \"$0 -h\"."
  sleep 3
  exit 1
fi
}
chk_var -k ${SCKEYS}
chk_var -t ${TITLE}
SCKEYS=$(echo ${SCKEYS} | tr "," " ")
MSG=""
MSG="text=${TITLE}"
if [[ -n "${CONTENT}" ]]; then
  MSG="${MSG}&desp=${CONTENT}"
fi
for SCKEY in ${SCKEYS}; do
  URL=https://sc.ftqq.com/${SCKEY}.send
  curl -d "${MSG}" -X POST ${URL}
done
