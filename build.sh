# Script to Build and Upload HAVOC_ASUS build.xml
# ComicoX

# Function to Setup Global Parameters
setup() {
    # Set build and directory parameters
    export BUILDd=~/havoc

    export OUT7d=/home/shared/ComicoX/OUT_DIR/havoc/havoc/target/product/I002D/
    export OUT6d=/home/shared/ComicoX/OUT_DIR/havoc/havoc/target/product/I01WD/

    cd $BUILDd

    . build/envsetup.sh
}

# Function to Sync build
sync() {
    #Export the manifest path
    export ROMd=~/havoc/.repo/local_manifests

    #Check if it exists
    if
        [ ! -d $ROMd ];
	        then
        mkdir -pv $ROMd ;
            else
        echo ' roomservice dir exists '
    fi

    #Export the manifest url
    export DEVICEurl=https://raw.githubusercontent.com/ComicoTeam/android_local_manifests_asus/havoc-eleven/local_manifests/local_manifests.xml

    #Delete the existing manfiest
    rm -v $ROMd/*.xml

    #Download the new one
    wget -O $ROMd/HAVOC.xml $DEVICEurl

    #Start the sync
    repo sync -c -j16 --force-sync --no-clone-bundle --no-tags

    #Reload the script at the end
}

# Function to BUILD ZENFONE 7 without gapps
zen7() {
    #Announce the build
    echo 'Zenfone 7'

    #Start the build
    brunch I002D

    #Cd to the build output
    cd $OUT7d

    #Get the file name
    filenameZen7=$(basename *I002D-Official.zip)

    #Copy the ROM to the root of Havoc sources
    mv $filenameZen7 $BUILDd/$filenameZen7

    #Cd back to the root dir
    cd $BUILDd

    #Make clean
    make clean

    #Exit the script
    exit 0
}

# Function to BUILD ZENFONE 7 with gapps
zen7Gapps() {
    . build/envsetup.sh
    echo 'Zenfone 7 GAPPS'
    export WITH_GAPPS=true
    export TARGET_GAPPS_ARCH=arm64
    brunch I002D
    cd $OUT7d
    filenameZen7Gapps=$(basename *I002D-Official-GApps.zip)
    mv $filenameZen7Gapps $BUILDd/$filenameZen7Gapps
    cd $BUILDd
    make clean
    exit 0
}

# Function to BUILD ZENFONE 7 without gapps then with gapps
zen7Full() {
    echo 'Zenfone 7 FULL'
    brunch I002D
    cd $OUT7d
    filenameZen7=$(basename *I002D-Official.zip)
    mv $filenameZen7 $BUILDd/$filenameZen7
    cd $BUILDd
    make clean
    export WITH_GAPPS=true
    export TARGET_GAPPS_ARCH=arm64
    brunch I002D
    cd $OUT7d
    filenameZen7Gapps=$(basename *I002D-Official-GApps.zip)
    mv $filenameZen7Gapps $BUILDd/$filenameZen7Gapps
    cd $BUILDd
    make clean
    exit 0
}

# Function to BUILD ZENFONE 6 without gapps
zen6() {
    echo 'Zenfone 6'
    brunch I01WD
    cd $OUT6d
    filenameZen6=$(basename *I01WD-Official-GApps.zip)
    mv $filenameZen6 $BUILDd/$filenameZen6
    cd $BUILDd
    make clean
    exit 0
}

# Function to BUILD ZENFONE 6 with gapps
zen6Gapps() {
    echo 'Zenfone 6 GAPPS'
    export WITH_GAPPS=true
    export TARGET_GAPPS_ARCH=arm64
    brunch I01WD
    cd $OUT6d
    filenameZen6Gapps=$(basename *I01WD-Official-GApps.zip)
    mv $filenameZen6Gapps $BUILDd/$filenameZen6Gapps
    cd $BUILDd
    make clean
    exit 0
}

# Function to BUILD ZENFONE 6 without gapps then with gapps
zen6Full() {
    echo 'Zenfone 6 FULL'
    brunch I01WD
    cd $OUT6d
    filenameZen6=$(basename *I01WD-Official.zip)
    mv $filenameZen6 $BUILDd/$filenameZen6
    cd $BUILDd
    make clean
    export WITH_GAPPS=true
    export TARGET_GAPPS_ARCH=arm64
    brunch I01WD
    cd $OUT6d
    filenameZen6Gapps=$(basename *I01WD-Official-GApps.zip)
    mv $filenameZen6Gapps $BUILDd/$filenameZen6Gapps
    cd $BUILDd
    make clean
    exit 0
}

# Function to BUILD everything
zenFull() {
    echo 'Zenfone 6 FULL'
    brunch I01WD
    cd $OUT6d
    filenameZen6=$(basename *I01WD-Official.zip)
    mv $filenameZen6 $BUILDd/$filenameZen6
    cd $BUILDd
    make clean
    export WITH_GAPPS=true
    export TARGET_GAPPS_ARCH=arm64
    brunch I01WD
    cd $OUT6d
    filenameZen6Gapps=$(basename *I01WD-Official-GApps.zip)
    mv $filenameZen6Gapps $BUILDd/$filenameZen6Gapps
    cd $BUILDd
    make clean
    echo 'Zenfone 7 FULL'
    brunch I002D
    cd $OUT7d
    filenameZen7=$(basename *I002D-Official.zip)
    mv $filenameZen7 $BUILDd/$filenameZen7
    cd $BUILDd
    make clean
    export WITH_GAPPS=true
    export TARGET_GAPPS_ARCH=arm64
    brunch I002D
    cd $OUT7d
    filenameZen7Gapps=$(basename *I002D-Official-GApps.zip)
    mv $filenameZen7Gapps $BUILDd/$filenameZen7Gapps
    cd $BUILDd
    make clean
}

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
    echo "  4. Zenfone 6"
    echo "  5. Zenfone 6 GAPPS"
    echo "  6. Zenfone 6 FULL"
    echo "  7. Zenfone 6 && 7 FULL"
    echo "  9. EXIT"
    echo ""
}

# Function to read menu input selection and take a action
read_options(){
    local choice
    read -p "Enter choice [ 0 - 6 ] " choice
    case $choice in
    0) sync;;
    1) zen7;;
    2) zen7Gapps;;
    3) zen7Full;;
    4) zen6;;
    5) zen6Gapps;;
    6) zen6Full;;
    7) zenFull;;
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
