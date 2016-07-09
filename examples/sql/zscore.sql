-- zscore.sql
-- Perform z-score calculation
--
select (
    t.${hiveconf:primaryid},
    t.${hiveconf:secondaryid},
        (if ((100 * t.score - stats.avg) / stats.var > 4, 4, (100 * t.score - stats.avg) / stats.var)) -- if/else; max @ 4
    zscore
) from (
    select
        ${hiveconf:primaryid},
            avg(score)
        avg,
            (stddev_pop(score) + 0.1)
        var
    from
        ${hiveconf:source_table}
    where
        tscomputed = '${hiveconf:source_tscomputed}'
    group by
        ${hiveconf:primaryid}
) stats join ${hiveconf:source_table} t on (
        t.${hiveconf:primaryid} = stats.${hiveconf:primaryid} and 
        t.tscomputed = '${hiveconf:source_tscomputed}'
)
