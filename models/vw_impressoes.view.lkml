view: vw_impressoes {
  derived_table: {
    sql: WITH
        IMPRESSOES_DIAS AS (
        SELECT
          x.dimension_ad_unit_id,
          ab.dimension_ad_unit_name,
          min(x.total_impressoes) total_impressoes,
          sum(ab.column_total_line_item_level_impressions) total_impressoes_2,
          CAST(x.dimension_date AS TIMESTAMP) AS dimension_date,
          x.dimension_date AS data

        FROM
         (select dimension_date , dimension_ad_unit_id,sum(a.column_total_line_item_level_impressions ) total_impressoes from `ga360-270104.gam.pagina_anuncio_bloco` a
         group by dimension_date , dimension_ad_unit_id) x
        LEFT JOIN
          `ga360-270104.gam.anuncio_bloco` ab
       ON
          x.dimension_ad_unit_id = ab.dimension_ad_unit_id
          AND x.dimension_date = ab.dimension_date
          --WHERE ab.dimension_ad_unit_name  like '%2020_unum_desk_horizontal_top_post%'
        --and x.dimension_date = '2020-02-18'
        group by x.dimension_ad_unit_id,
          ab.dimension_ad_unit_name,x.dimension_date
        ORDER BY
          5 DESC),
        SESSOES AS (
        SELECT
        cast((date(timestamp(trim(CONCAT(SUBSTR(DATE, 1,4),"-", SUBSTR(DATE, 5,2),"-", SUBSTR(DATE, 7,2)))))) AS TIMESTAMP) as date_sessoes,
        COUNT(DISTINCT CONCAT(fullVisitorId, CAST(visitStartTime AS STRING))) tot_sessoes
        FROM
        `ga360-270104.197733498.ga_sessions_2020*`, UNNEST(hits) AS h
        WHERE
        h.type='PAGE'
        GROUP BY
        date_sessoes ),
        ------
        IMPRESSOES_MEDIA AS(
        SELECT
          p.dimension_ad_unit_id,
          p.dimension_ad_unit_name,
          SUM(p.column_total_line_item_level_impressions)total_impressoes,
          SUM(p.column_total_line_item_level_impressions) / 7 MEDIA_7DIAS
        FROM
          `ga360-270104.gam.pagina_anuncio_bloco` p
        WHERE
          DATE(CAST(p.dimension_date as TIMESTAMP)) BETWEEN DATE_SUB(CURRENT_DATE(), INTERVAL 7 DAY)
          AND CURRENT_DATE()
          --AND p.dimension_ad_unit_id  = 21894546418
        GROUP BY
          p.dimension_ad_unit_id,
          p.dimension_ad_unit_name
        ORDER BY
          3 DESC)
      SELECT
        D.*,
        ROUND(M.MEDIA_7DIAS,2) MEDIA_7DIAS,
        ROUND((D.total_impressoes / M.MEDIA_7DIAS )* 100,2) PERCENT_ATINGIDO,
        CASE
          WHEN D.TOTAL_IMPRESSOES >= M.MEDIA_7DIAS THEN 'ACIMA DA MEDIA'
        ELSE
        'ABAIXO DA MEDIA'
      END
        SITUACAO,
        S.TOT_SESSOES
      FROM
        IMPRESSOES_DIAS D
      INNER JOIN
        IMPRESSOES_MEDIA M
      ON
        D.dimension_ad_unit_id = M.dimension_ad_unit_id
      LEFT JOIN
        SESSOES S
      ON
        CAST(D.data AS TIMESTAMP) = CAST(S.date_sessoes AS TIMESTAMP)
        order by 5 desc
      --ORDER BY
      --  5 DESC
             ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: dimension_ad_unit_id {
    type: number
    sql: ${TABLE}.dimension_ad_unit_id ;;
  }

  dimension: dimension_ad_unit_name {
    type: string
    sql: ${TABLE}.dimension_ad_unit_name ;;
    bypass_suggest_restrictions: yes
  }

  measure: total_impressoes {
    type: sum
    sql: ${TABLE}.total_impressoes ;;
  }

  measure: total_impressoes_2 {
    type: sum
    label: "Total Impressoes Bloco"
    sql: ${TABLE}.total_impressoes_2 ;;
  }

  dimension: data {
    type: date
    sql: ${TABLE}.data ;;
  }

  dimension_group: dimension_date {
    type: time
    sql: ${TABLE}.dimension_date ;;
  }

  measure: media_7_dias {
    type: sum
    sql: ${TABLE}.MEDIA_7DIAS ;;
  }

  measure: percent_atingido {
    type: sum
    sql: ${TABLE}.PERCENT_ATINGIDO ;;
  }

  dimension: situacao {
    type: string
    sql: ${TABLE}.SITUACAO ;;
  }

  measure: tot_sessoes {
    type: sum
    sql: ${TABLE}.TOT_SESSOES ;;
  }

  set: detail {
    fields: [
      dimension_ad_unit_id,
      dimension_ad_unit_name,
      total_impressoes,
      total_impressoes_2,
      data,
      dimension_date_time,
      media_7_dias,
      percent_atingido,
      situacao,
      tot_sessoes
    ]
  }
}
