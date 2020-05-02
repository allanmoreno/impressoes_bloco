view: impressoes_anuncio_bloco {
  derived_table: {
    sql: select dimension_ad_unit_name,dimension_date ,dimension_hour,sum(column_total_line_item_level_impressions )  total_impressoes FROM
          `ga360-270104.gam.pagina_anuncio_bloco`
          group by dimension_ad_unit_name,dimension_date ,dimension_hour
          order by 2 desc,3
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: dimension_ad_unit_name {
    type: string
    sql: ${TABLE}.dimension_ad_unit_name ;;
  }

  dimension_group: dimension_date {
    type: time
    sql: ${TABLE}.dimension_date ;;
  }

  dimension: dimension_hour {
    type: number
    sql: ${TABLE}.dimension_hour ;;
  }

  measure: total_impressoes {
    type: sum
    sql: ${TABLE}.total_impressoes ;;
  }

  set: detail {
    fields: [dimension_ad_unit_name, dimension_date_time, dimension_hour, total_impressoes]
  }
}
