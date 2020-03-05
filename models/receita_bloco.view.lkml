view: receita_bloco {
  derived_table: {
    sql: SELECT dimension_ad_unit_id ,dimension_ad_unit_name,dimension_date ,
          round((column_total_line_item_level_all_revenue / 1000000),2) receita,
          round(lag (column_total_line_item_level_all_revenue / 1000000) over (order by dimension_ad_unit_id,dimension_date ),2) as receita_dia_ant,


       CASE WHEN lag (column_total_line_item_level_all_revenue / 1000000) over (order by dimension_ad_unit_id,dimension_date ) = 0 THEN 0 ELSE

         round((     (column_total_line_item_level_all_revenue / 1000000)  /  (lag (column_total_line_item_level_all_revenue / 1000000) over (order by dimension_ad_unit_id,dimension_date ))   - 1) *100,2) END variacao_percent,

          column_total_line_item_level_clicks ,
          lag (column_total_line_item_level_clicks ) over (order by dimension_ad_unit_id ,dimension_date) as total_clicks_ant,

          CASE WHEN  lag (column_total_line_item_level_clicks ) over (order by dimension_ad_unit_id ,dimension_date) = 0 THEN 0 ELSE

        round((( column_total_line_item_level_clicks / lag (column_total_line_item_level_clicks ) over (order by dimension_ad_unit_id ,dimension_date))-1)*100,2) end variacao_total_clicks,

          column_total_line_item_level_impressions,
          lag (column_total_line_item_level_impressions ) over (order by dimension_ad_unit_id , dimension_date) as total_level_impressoes_ant,

          CASE WHEN lag (column_total_line_item_level_impressions / 1000000) over (order by dimension_ad_unit_id,dimension_date ) = 0 THEN 0 ELSE
         round(( ((column_total_line_item_level_impressions / 1000000) /lag (column_total_line_item_level_impressions/1000000 ) over (order by dimension_ad_unit_id,dimension_date ))-1)*100,2) end as variacao_total_level_impression


          FROM `etusbg.dfp_publishers.receita_bloco`
         -- where dimension_ad_unit_id  = 21894740639
          order by 3 desc,4 desc
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
  }

  dimension_group: dimension_date {
    type: time
    sql: ${TABLE}.dimension_date ;;
  }

  measure: receita {
    type: sum
    sql: ${TABLE}.receita ;;
  }

  measure: receita_dia_ant {
    type: sum
    sql: ${TABLE}.receita_dia_ant ;;
  }

  measure: variacao_percent {
    type: sum
    sql: ${TABLE}.variacao_percent ;;
  }

  measure: column_total_line_item_level_clicks {
    type: sum
    sql: ${TABLE}.column_total_line_item_level_clicks ;;
  }

  measure: total_clicks_ant {
    type: sum
    sql: ${TABLE}.total_clicks_ant ;;
  }

  measure: variacao_total_clicks {
    type: sum
    sql: ${TABLE}.variacao_total_clicks ;;
  }

  measure: column_total_line_item_level_impressions {
    type: sum
    sql: ${TABLE}.column_total_line_item_level_impressions ;;
  }

  measure: total_level_impression_ant {
    type: sum
    sql: ${TABLE}.total_level_impressoes_ant ;;
  }

  measure: variacao_total_level_impression {
    type: sum
    sql: ${TABLE}.variacao_total_level_impression ;;
  }

  set: detail {
    fields: [
      dimension_ad_unit_id,
      dimension_ad_unit_name,
      dimension_date_time,
      receita,
      receita_dia_ant,
      variacao_percent,
      column_total_line_item_level_clicks,
      total_clicks_ant,
      variacao_total_clicks,
      column_total_line_item_level_impressions,
      total_level_impression_ant,
      variacao_total_level_impression
    ]
  }
}
