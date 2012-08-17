-- zscore.sql
-- Perform z-score calculation
--
select
    t.${hiveconf:primaryid},
    t.${hiveconf:secondaryid},
    if (
        (100 * t.score - stats.avg)
        / stats.var > 4,
        4,
        (100 * t.score - stats.avg)
        / stats.var
    ) zscore
from
    (
        select
            ${hiveconf:primaryid},
            avg(score) avg,
            stddev_pop(score) + 0.1 var
        from
            ${hiveconf:source_table}
        where
            and tscomputed = '${hiveconf:source_tscomputed}'
        group by
            ${hiveconf:primaryid}
    ) stats
    join ${hiveconf:source_table} t
            and t.tscomputed = '${hiveconf:source_tscomputed}'
            and t.${hiveconf:primaryid} = stats.${hiveconf:primaryid})
