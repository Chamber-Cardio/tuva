{{ config(
     enabled = var('pqi_enabled',var('claims_enabled',var('tuva_marts_enabled',False))) | as_bool
   )
}}

select
    e.data_source
  , e.patient_id
  , e.year_number
  , e.encounter_id
  , '{{ var('tuva_last_run')}}' as tuva_last_run
from {{ ref('ahrq_measures__stg_pqi_inpatient_encounter') }} as e
inner join {{ ref('pqi__value_sets') }} as hyp
  on e.primary_diagnosis_code = hyp.code
  and hyp.value_set_name = 'hypertension_diagnosis_codes'
  and hyp.pqi_number = '07'
inner join {{ ref('ahrq_measures__int_pqi_07_denom') }} as denom
  on e.patient_id = denom.patient_id
  and e.data_source = denom.data_source
  and e.year_number = denom.year_number
left join {{ ref('ahrq_measures__int_pqi_07_exclusions') }} as shared
  on e.encounter_id = shared.encounter_id
  and e.data_source = shared.data_source
where shared.encounter_id is null
