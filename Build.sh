#!/bin/bash 

ScriptPath=$(cd "$(dirname "$0")"; pwd)

OUTPUTDIR=build

SkinPath=$ScriptPath
TexturePackerPath=/Applications/TexturePacker
OutputPath=$SkinPath/$OUTPUTDIR



Usage()
{
cat <<-ENDOFMESSAGE

$0 [OPTION] REQ1 REQ2

options:

    -o -output  Path to output to
    -s -skin  Path to the skin to build
    -p -path  Path to TexturePacker installation
    -h --help   display this message

ENDOFMESSAGE
    exit 1
}

Die()
{
    echo "$*"
    exit 1
}

GetOpts() {
    branch="master"
    argv=
    while [ $# -gt 0 ]
    do
        opt=$1
        shift
        case ${opt} in
            -p|--packer)
                if [ $# -eq 0 -o "${1:0:1}" = "-" ]; then
                    Die "The ${opt} option requires an argument."
                fi
                TexturePackerPath="$1"
                shift
                ;;
            -s|--skin)
                if [ $# -eq 0 -o "${1:0:1}" = "-" ]; then
                    Die "The ${opt} option requires an argument."
                fi
                SkinPath="$1"
                shift
                ;;
            -o|--output)
                if [ $# -eq 0 -o "${1:0:1}" = "-" ]; then
                    Die "The ${opt} option requires an argument."
                fi
                OutputPath="$1"
                shift
                ;;
            -h|--help)
                Usage;;
            *)
                if [ "${opt:0:1}" = "-" ]; then
                    Die "${opt}: unknown option."
                fi
                argv+=${opt};;
        esac
    done
}

GetOpts $*

SkinName=$(basename "${SkinPath}")
echo "TexturePackerPath ${TexturePackerPath}"
echo "SkinPath ${SkinPath}"
echo "OutputPath ${OutputPath}"
echo "ScriptPath ${ScriptPath}"
echo "argv ${argv}"
echo "Skin Name ${SkinName}"

echo Creating reFocus Build Folder
rm -fr "$OutputPath"
mkdir "$OutputPath"
mkdir "$OutputPath/$SkinName"

echo Building Skin Directory...

for directory in $( ls "${SkinPath}" )
do
     if [ \( $directory != 'media' -a $directory != 'build' -a $directory != 'build.sh' \) ]; then
         cp -R "${SkinPath}/$directory" "$OutputPath/$SkinName/$directory"
     fi
done

echo Creating XBT File...
cd "${TexturePackerPath}"
mkdir "$OutputPath/$SkinName/media"
./TexturePacker -dupecheck -input "${SkinPath}/media/" -output "$OutputPath/$SkinName/media/Textures.xbt"
cd -
echo Build Complete - Scroll Up to check for errors.