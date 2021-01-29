# Script to Build and Upload HAVOC_ASUS build.xml
# Comico

# Function to Setup Global Parameters
setup() {
    # Set build and directory parameters
    export BUILDd=~/havoc

    export zenout=/home/shared/ComicoX/OUT_DIR/havoc/target/product/I002D

    cd $BUILDd

    . build/envsetup.sh
}

# Function to Sync build
sync() {
    #Export the manifest path
    export ROOMd=~/havoc/.repo/local_manifests

    #Check if it exists
    if 
        [ ! -d $ROOMd ];
	        then
        mkdir -pv $ROOMd ;
            else
        echo ' roomservice dir exists ' 
    fi

    #Export the manifest url
    export ROOMs=https://raw.githubusercontent.com/ComicoTeam/android_local_manifests_asus/havoc-eleven/local_manifests/local_manifests.xml

    #Delete the existing manfiest
    rm -v $ROOMd/*.xml

    #Download the new one
    wget -O $ROOMd/HAVOC.xml $ROOMs

    #Start the sync
    repo sync -c -j16 --force-sync --no-clone-bundle --no-tags

    #Reload the script at the end
}

# Function to BUILD ZENFONE 7 without gapps
zen() {
    #Announce the build
    echo 'Zenfone 7'

    #Start the build
    brunch I002D

    #Cd to the build output
    #cd $zenout
    
    #Get the file name
    #filenameZen=$(basename *I002D-Official*.zip)

    #Copy the file
    #mv $filenameZen $OUT_DIR_COMMON_BASE/$filenameZen

    #Make clean
    #make clean DISABLE CLEANING FOR NOW AND UPLOADING

    #Upload the zip
    #gdrive upload $filenameZen

    #Exit the script
    exit 0
}

# Function to BUILD ZENFONE 6 with gapps
zenGapps() {
    echo 'Zenfone 7 GAPPS'
    export WITH_GAPPS=true
    export TARGET_GAPPS_ARCH=arm64
    brunch I002D
    #cd $zenout
    #filenameZenG=$(basename *I01WD-Official-GApps*.zip)
    #mv $filenameZenG $OUT_DIR_COMMON_BASE/$filenameZenG
    #make clean
    #gdrive upload $filenameZenG DISABLE CLEANING FOR NOW AND UPLOADING
    exit 0
}

# Function to BUILD ZENFONE 6 without gapps then with gapps
#zenFull() {
#    echo 'Zenfone 7 FULL'
#    brunch I01WD
#    cd $zenout
#    filenameZen=$(basename *I01WD-Official*.zip)
#    mv $filenameZen $OUT_DIR_COMMON_BASE/$filenameZen
#    make clean
#    sshpass -p <PASSWORD> sftp <USER>@<url>:<pathToWhereOnServer> <<< $'put $filenameZen'
#    export WITH_GAPPS=true
#    export TARGET_GAPPS_ARCH=arm64
#    brunch I01WD
#    cd $zenout
#    filenameZenG=$(basename *I01WD-Official-GApps*.zip)
#    mv $filenameZenG $OUT_DIR_COMMON_BASE/$filenameZenG
#    make clean
#    sshpass -p <PASSWORD> sftp <USER>@<url>:<pathToWhereOnServer> <<< $'put $filenameZenG'
#    exit 0
#} DISABLED FOR NOW


# Function to display menu options
show_menus() {
    clear
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    echo " BUILD Menu"
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    echo "  0. SYNC REPO"
    echo "  1. Zenfone 7"
    echo "  2. Zenfone 7 GAPPS"
    echo "  3. Zenfone 7 FULL"
    echo "  9. EXIT"
    echo ""
}

# Function to read menu input selection and take a action
read_options(){
    local choice
    read -p "Enter choice [ 0 - 6 ] " choice
    case $choice in
    0) sync;;
    1) zen;;
    2) zenGapps;;
    9) exit 0;;
    *) echo -e "${RED}Error...${STD}" && sleep 2
    esac
}

# Function for menu
do_menu() {

    # Run setup function
    setup

    # Main menu handler loop
    while true
    do
        show_menus
        read_options
    done
}

# Display menu on run
do_menu
