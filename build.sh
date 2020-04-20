# Script to Build and Upload HAVOC_ASUS build.xml
# Comico

# Function to Setup Global Parameters
setup() {
    # Server Specific compile settings
    . ~/bin/compile.sh

    # Set build and directory parameters
    export BUILDd=~/havoc

    export OUT_DIR_COMMON_BASE=home/shared/ComicoX
    export zenout=$OUT_DIR_COMMON_BASE/havoc/target/product/I01WD
    export rogout=$OUT_DIR_COMMON_BASE/havoc/target/product/I001D

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
    #Delete the existing manfiest
    rm -v $ROOMd/*.xml

    #Download the new one
    wget -O $ROOMd/HAVOC.xml $ROOMs

    #Start the sync
    repo sync -c -j16 --force-sync --no-clone-bundle --no-tags

    #Reload the script at the end
}

# Function to BUILD ZENFONE 6 without gapps
zen() {
    #Announce the build
    echo 'Zenfone 6'

    #Start the build
    brunch I01WD

    #Cd to the build output
    cd $zenout
    
    #Get the file name
    filenameZen=$(basename *I01WD-Official*.zip)

    #Copy the file

    #Make clean
    make clean

    #Upload the zip
    gdrive upload $filenameZen

    #Exit the script
    exit 0
}

# Function to BUILD ZENFONE 6 with gapps
zenGapps() {
    echo 'Zenfone 6 GAPPS'
    export WITH_GAPPS=true
    export TARGET_GAPPS_ARCH=arm64
    brunch I01WD
    cd $zenout
    filenameZenG=$(basename *I01WD-Official-GApps*.zip)
    mv $filenameZenG $OUT_DIR_COMMON_BASE
    make clean
    gdrive upload $filenameZenG
    exit 0
}

# Function to BUILD ZENFONE 6 without gapps then with gapps
zenFull() {
    echo 'Zenfone 6 FULL'
    brunch I01WD
    cd $zenout
    filenameZen=$(basename *I01WD-Official*.zip)
    mv $filenameZen $OUT_DIR_COMMON_BASE
    make clean
    sshpass -p <PASSWORD> sftp <USER>@<url>:<pathToWhereOnServer> <<< $'put $filenameZen'
    export WITH_GAPPS=true
    export TARGET_GAPPS_ARCH=arm64
    brunch I01WD
    cd $zenout
    filenameZenG=$(basename *I01WD-Official-GApps*.zip)
    mv $filenameZenG $OUT_DIR_COMMON_BASE
    make clean
    sshpass -p <PASSWORD> sftp <USER>@<url>:<pathToWhereOnServer> <<< $'put $filenameZenG'
    exit 0
}

# Function to BUILD ROG PHONE II WITH GAPPS
rogGapps() {
    echo 'Rog PHONE II GAPPS'
    export WITH_GAPPS=true
    export TARGET_GAPPS_ARCH=arm64
    brunch I001D
    cd $rogout
    filenameRogG=$(basename *I001D-Unofficial-GApps*.zip)
    mv $filenameRogG $OUT_DIR_COMMON_BASE
    make clean
    gdrive upload $filenameRogG
    exit 0
}

# Function to display menu options
show_menus() {
    clear
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    echo " BUILD Menu"
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    echo "  0. SYNC REPO"
    echo "  1. Zenfone 6"
    echo "  2. Zenfone 6 GAPPS"
    echo "  3. Zenfone 6 FULL"
    echo "  4. ROG PHONE II GAPPS"
    echo "  5. EXIT"
    echo ""
}

# Function to read menu input selection and take a action
read_options(){
    local choice
    read -p "Enter choice [ 0 - 5 ] " choice
    case $choice in
    0) sync;;
    1) zen;;
    2) zenGapps;;
    3) zenFULL;;
    4) rogGapps;;
    5) exit 0;;
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
