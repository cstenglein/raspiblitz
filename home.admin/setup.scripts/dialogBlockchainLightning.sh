#!/bin/bash

# get basic system information
# these are the same set of infos the WebGUI dialog/controler has
source /home/admin/raspiblitz.info

# SETUPFILE
# this key/value file contains the state during the setup process
SETUPFILE="/var/cache/raspiblitz/temp/raspiblitz.setup"
source $SETUPFILE

# values to determine by dialogs
network=""
lightning=""

# chose blockchain
OPTIONS=()
OPTIONS+=(BITCOIN "Setup BITCOIN Blockchain (BitcoinCore)")
OPTIONS+=(LITECOIN "Setup LITECOIN Blockchain")
CHOICE=$(dialog --clear \
                --backtitle "RaspiBlitz ${codeVersion} - Setup" \
                --title "⚡ Blockchain ⚡" \
                --menu "\nChoose which Blockchain to run: \n " \
                11 64 5 \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)
clear
case $CHOICE in
        BITCOIN)
            # bitcoin core
            network="bitcoin"
            ;;
        LITECOIN)
            # litecoin
            network="litecoin"
            # can only work with LND
            lightning="lnd"
            ;;
        *)
            clear
            echo "User Cancel"
            exit 1
esac

if [ "${network}" == "bitcoin" ]; then

     # choose lightning client
    OPTIONS=()
    OPTIONS+=(LND "LND - Lightning Network Daemon (DEFAULT)")
    OPTIONS+=(CLN "c-lightning by blockstream (fewer Apps)")
    OPTIONS+=(NONE "Run without Lightning")
    CHOICE=$(dialog --clear \
                --backtitle "RaspiBlitz ${codeVersion} - Setup" \
                --title "⚡ Lightning ⚡" \
                --menu "\nChoose your Lightning Client: \n " \
                13 64 7 \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)
    clear
case $CHOICE in
        LND)
            lightning="lnd"
            ;;
        CLN)
            lightning="cln"
            ;;
        NONE)
            lightning=""
            ;;
        *)
            clear
            echo "User Cancel"
            exit 1
esac

# write results to setup sate
echo "lightning=${lightning}" >> $SETUPFILE
echo "network=${network}" >> $SETUPFILE

exit 0