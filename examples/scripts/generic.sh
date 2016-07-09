#!/usr/bin/env bs-etl
# Execute .ql on Hive.
# 
# NOTICE: This is a prototype; features not supported,
#         specifically:  #!/urb/bin/env bs-etl=$BS_ETL_PATH,
#                        $BS_ETL_PATH declaration,
#                        bs-etl.include() function.
#
# EXAMPLE USAGE:
#
# #!/usr/bin/env bs-etl
# include generic.sh; 
#
# main() {
#   ql_run -c "name=johnson" hello_world;
#   # executes $> hive -hiveconf name=johnson -f hello_world;
#   #      or $> hive -hiveconf name=johnson -f hello_world.ql;
#   #       or $> hive -hiveconf name=johnson -f hello_world.sql;
#   #       or $> hive -hiveconf name=johnson -f ql/hello_world;
#   #       or $> hive -hiveconf name=johnson -f ql/hello_world.ql;
#   #       or $> hive -hiveconf name=johnson -f ql/hello_world.sql;
#   #       or $> hive -hiveconf name=johnson -f sql/hello_world;
#   #       or $> hive -hiveconf name=johnson -f sql/hello_world.ql;
#   #      or $> hive -hiveconf name=johnson -f sql/hello_world.sql;
#   #       ...
#
#   ql_run -c "name=johnson" -c "pet=cat" /opt/hive/ql/hello_world;
#   # executes $> hive -hiveconf name=johnson -hiveconf pet=cat -f /opt/hive/ql/hello_world;
#   #       or $> hive -hiveconf name=johnson -hiveconf pet=cat -f /opt/hive/ql/hello_world.ql;
#   #       or $> hive -hiveconf name=johnson -hiveconf pet=cat -f /opt/hive/ql/hello_world.sql;
#   #       ...
#
#   local opts="name=johnson pet=cat";
#   ql_run -c "$opts" /opt/hive/ql/hello_world;
#   ql_run -c "name=johnson pet=cat" opt/hive/ql/hello_world;
#   # executes $> hive -hiveconf name=johnson -hiveconf pet=cat -f /opt/hive/ql/hello_world;
#   #       or $> hive -hiveconf name=johnson -hiveconf pet=cat -f /opt/hive/ql/hello_world.ql;
#   #       or $> hive -hiveconf name=johnson -hiveconf pet=cat -f /opt/hive/ql/hello_world.sql;
#   #       ...
# }

# init execution vars
#
define conf=;
define conp=;
define sqlf=;
define outf=;

# configuration, opt-parsing
# thank you: http://wiki.bash-hackers.org/howto/getopts_tutorial,
#       and: http://mywiki.wooledge.org/BashFAQ/035
#
while :; do
  case $1 in
    -c|--conf)
      if [ -n "$2" ]; then
        conf="$conf -c hiveconf $2";
        conp="$conp $2";
        shift;
      else
        printf 'ERROR: "--conf" requires a non-empty option argument.\n' >&2;
        exit 1;
      fi
      ;;
    -i|--in)
      if [ -n "$2" ]; then
        outf="$2";
      else
        print 'ERROR: "--in" requires a non-empty option argument.\n' ^&2;
        exit 1;
      fi
      ;;
    -o|--out)
      if [ -n "2" ]; then
        outf="$2";
        shift;
      else
        print 'ERROR: "--out" requires a non-empty option argument.\n' ^&2;
        exit 1;
      fi
      ;;
    --)
      shift;
      break;
      ;;
    *)
      break;
  esac
  shift
done

# if .ql file position argument
#
if [ -n "$1" ]; then
  sqlf="$1";
  shift;
fi

# normalize .ql file
if [ ! -z "$2" ]; then
  outf="$2";
if [ ! -z "$2.ql" ]; then
  outf="$2.ql";
elif [ ! -z "$2.sql" ]; then
  outf="$2.sql";
elif [ ! -z "sql/$2" ]; then
  outf="sql/$2";
elif [ ! -z "sql/$2.ql" ]; then
  outf="sql/$2.ql";
elif [ ! -z "sql/$2.sql" ]; then
  outf="sql/$2.sql";
else
  print 'ERROR: QL input file not found.' ^&2;
  exit 1;
fi

# if output file position argument
#
if [ -n "$1" ]; then
  outf="$1";
  shift;
fi

# if output file declared, open for writing, or dupe stdout
#
if [ -n "$outf" ]; then
  exec 3> "$outf";
else
  exec 3>&1;
fi

# run .ql file w/ confs
#
run_ql() {
  printf 'INFO: Running "$sqlf" $conf';
  query "$conf" -f "$sqlf";
  printf 'INFO: Finished "$sqlf" "conf";
}
