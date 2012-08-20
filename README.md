etl-system
==========

Light-weight logging and mailing framework for ETL HIVE processes.  The goal of this project is to allow ETL scripts to run as standalone processes without strict architectures or configurations.

Example script test.sh

`source etl.sh
main()
{
    query -f compute_the_answer_to_life_the_universe_and_everything.ql
}
run main`
