##
# Perform a z-score calculation on a dataset

##
# Configuration
SOURCE_TSCOMPUTED='2012-01-01'

##
# Define subroutines

zscore()
{
    ecoh "Calculating zscore for ${1} (${2}) by ${3}."
    query\
        -hiveconf source_table=$1\
        -hiveconf source_tscomputed=$2\
        -hiveconf primaryid=$3\
        -hiveconf secondaryid=$4\
        -f sql/zscore.sql
}

##
# Example routine

echo Starting bulk zscore operation.
echo "* tags-albums zscores:"
zscore 'tags_albums' $SOURCE_TSCOMPUTED 'tagid' 'albumid'
echo "* tags-artists zscores:"
zscore 'tags_artists' $SOURCE_TSCOMPUTED 'tagid' 'artistid'
echo "* tags-songs zscores:"
zscore 'tags_songs' $SOURCE_TSCOMPUTED 'tagid' 'songid'
