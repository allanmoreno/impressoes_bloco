connection: "etusbg_connector"

datagroup: allan_dash_impressoes_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: allan_dash_impressoes_default_datagroup

include: vw_impressoes.view
explore: vw_impressoes {label: "TB_IMPRESSOES"}
include: impressoes_anuncio_bloco.view
explore:  impressoes_anuncio_bloco {label: "tb_impressoes_anuncio_bloco"}
