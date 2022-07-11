
drop table sasptmp.${t_name}_DRIVER_FILE_TY_S;

execute( CREATE TABLE sasptmp.${t_name}_DRIVER_FILE_TY_S, NO FALLBACK as
		(
			select distinct
			  cast(cast(a1.SHPG_TRXN_ID as format 'Z(I)') as varchar(50)) as shpg_trxn_id
			, a1.shpg_trxn_id as trxn_nbr
			, a1.shpg_trxn_ln_dt
			, a2.lgcy_sto_nbr
			, a2.loc_nme
			, a2.dist_nme
			, a2.rgn_nme
			, case when a1.loc_id = a3.sto_loc_id then 1 else 0 end as COMP_STR_FLG
			, case when a3.tier is null then 'NONE' else a3.tier end as tier
			, case when a2.lgcy_sto_nbr in (${si100}) then 1 else 0 end as SI100_FLG
			, x.sku_xref_id
			, x.sty_num
			, x.itm_sku_num
			, x.sbrnd_cd
			, x.itm_sbrnd_desc
			, x.itm_cls_desc
			, x.itm_scls_long_desc
			, x.PROD_CTGY_SHRT_DESC
			, x.styl_cd
			, x.itm_sty_desc
			, x.collection
			, x.itm_sty_id
			, x.chc_cd
			, cast(x.chc_cd_desc as varchar(80)) as chc_cd_desc
			, x.sz1_cd
			, x.sz2_cd
			, x.itm_sbrnd_cd
			, x.itm_scls_cd
			, x.itm_msty_cd
			, x.itm_msty_desc
			, x.pricing_pty_slp
			, x.brandcombo
			, x.categorycombo
			, x.detailcombo
			, case when a1.itm_clr_ind = 'Y' then 1 else 0 end as itm_clr_ind
			, a1.ext_prc_amt as Sales
			, a1.ln_itm_qty as Units
			, a1.unt_cst_amt as Cost
			, a1.ext_prc_amt - (a1.ln_itm_qty * a1.unt_cst_amt) as Margin
			, case  when categorycombo = 391 and collection like '%DR ANG CORE%' then '3FOR'
					when categorycombo = 391 and collection like '%BBV COLLECT%' then '3FOR'
					when categorycombo = 391 and collection like '%INCREDIBLE%' then '3FOR'
					when categorycombo = 391 and collection like '%SHEERSPACER%' then '3FOR'
					when categorycombo = 391 and collection like '%SLT CHEEKY%' then '3FOR'
					when categorycombo = 391 and collection like '%VS CORE%' then '3FOR'

					when categorycombo = 391 and itm_sbrnd_cd = 643 then '5FOR'
					when categorycombo = 391 and itm_sbrnd_cd = 644 then '5FOR'
					when categorycombo = 391 and itm_sbrnd_cd = 670 then '5FOR'
					when categorycombo = 391 and itm_sbrnd_cd = 2697 then '5FOR'
					when categorycombo = 391 and itm_sbrnd_cd = 2764 then '5FOR'
					when categorycombo = 391 and itm_sbrnd_cd = 9903 then '5FOR'

					when categorycombo = 391 and collection like '%DREAM ANGELS%' then 'CLEAN'
					when categorycombo = 391 and collection like '%DARK ROMANCE%' then 'CLEAN'
					when categorycombo = 391 and collection like '%BBV NONCOLEC%' then 'CLEAN'
					when categorycombo = 391 and collection like '%MDRN LINGRE%' then 'CLEAN'
					when categorycombo = 391 and collection like '%VS COLLECT%' then 'CLEAN'

					when categorycombo = 391 then 'OTHER_PTY' else 'OTHER_CTGY' end as PTY_COMBO

			from cdmpdataview.edw_shpg_trxn_line as a1

			join (	select distinct shpg_trxn_id from cdmpdataview.edw_shpg_trxn_line as a1
					join sasptmp.merchxref_stores as a2
					on a1.sku_xref_id = a2.sku_xref_id

					where a1.mkt_brnd_cd in (${mkt_brnd_cd})
					  and a1.shpg_trxn_ln_dt between ${start_dt} and ${end_dt}
					  and a1.shpg_trxn_ln_typ_cd in ('ID', 'IR', 'IX')
					  and (a1.gft_crd_sls_ind = 'N' or a1.gft_crd_sls_ind is null)
					  and (a1.ln_void_ind = 'N' or a1.ln_void_ind is null)
					  and a1.ext_prc_amt >= 0
					  and a1.ln_itm_qty > 0
					  and a2.brandcombo = ${vsl_combo}
				 ) as aa1
			on a1.shpg_trxn_id = aa1.shpg_trxn_id

			join sasptmp.merchxref_stores as x
			on a1.sku_xref_id = x.sku_xref_id

			join sasptmp.${t_name}_stores as a2
			on a1.loc_id = a2.sto_loc_id

			left join sasptmp.${t_name}_comp_stores as a3
			on a1.loc_id = a3.sto_loc_id

			where a1.mkt_brnd_cd in (${mkt_brnd_cd})
			  and a1.shpg_trxn_ln_dt between ${start_dt} and ${end_dt}
			  and a1.shpg_trxn_ln_typ_cd in ('ID', 'IR', 'IX')
			  and (a1.gft_crd_sls_ind = 'N' or a1.gft_crd_sls_ind is null)
			  and (a1.ln_void_ind = 'N' or a1.ln_void_ind is null)
			  and a1.ext_prc_amt >= 0
			  and a1.ln_itm_qty > 0

		) WITH DATA AND STATS primary index(shpg_trxn_id, lgcy_sto_nbr, styl_cd, chc_cd)
	  ) by tera;
execute(commit work) by tera;
execute(grant all on sasptmp.${t_name}_DRIVER_FILE_TY_S to ${users}) by tera;


drop table sasptmp.${t_name}_DRIVER_FILE_TY_D;

execute(CREATE TABLE sasptmp.${t_name}_DRIVER_FILE_TY_D, NO FALLBACK AS
		(
			select distinct
			  h.ord_id as shpg_trxn_id
			, 0 as trxn_nbr
			, h.ord_cre_dt as shpg_trxn_ln_dt
			, 9999 as lgcy_sto_nbr
			, 'DGTL' as loc_nme
			, 'DGTL' as dist_nme
			, 'DIGITAL' as rgn_nme
			, 0 as COMP_STR_FLG
			, 'DIG' as tier
			, 0 as S1100_FLG
			, 0 as sku_xref_id
			, x.sty_num
			, x.itm_sku_num
			, x.sbrnd_cd
			, x.itm_sbrnd_desc
			, x.itm_cls_desc
			, x.itm_scls_long_desc
			, x.PROD_CTGY_SHRT_DESC
			, x.styl_cd
			, x.itm_sty_desc
			, x.collection
			, x.itm_sty_id
			, x.chc_cd
			, cast(x.chc_cd_desc as varchar(80)) as chc_cd_desc
			, x.sz1_cd
			, x.sz2_cd
			, x.itm_sbrnd_cd
			, x.itm_scls_cd
			, x.itm_msty_cd
			, x.itm_msty_desc
			, x.pricing_pty_slp
			, x.brandcombo
			, x.categorycombo
			, x.detailcombo
			, case when h.ord_ln_prc_ind like 'Clearance%' then 1 else 0 end as itm_clr_ind
			, h.BEF_OFR_DMND_RTL_AMT as Sales
			, h.GRS_DMND_UNT_NBR as Units
			, h.GRS_DMND_ITM_CST_AMT as Cost
			, h.BEF_OFR_DMND_RTL_AMT - h.GRS_DMND_ITM_CST_AMT as Margin
			, case  when categorycombo = 391 and collection like '%DR ANG CORE%' then '3FOR'
					when categorycombo = 391 and collection like '%BBV COLLECT%' then '3FOR'
					when categorycombo = 391 and collection like '%INCREDIBLE%' then '3FOR'
					when categorycombo = 391 and collection like '%SHEERSPACER%' then '3FOR'
					when categorycombo = 391 and collection like '%SLT CHEEKY%' then '3FOR'
					when categorycombo = 391 and collection like '%VS CORE%' then '3FOR'

					when categorycombo = 391 and itm_sbrnd_cd = 643 then '5FOR'
					when categorycombo = 391 and itm_sbrnd_cd = 644 then '5FOR'
					when categorycombo = 391 and itm_sbrnd_cd = 670 then '5FOR'
					when categorycombo = 391 and itm_sbrnd_cd = 2697 then '5FOR'
					when categorycombo = 391 and itm_sbrnd_cd = 2764 then '5FOR'
					when categorycombo = 391 and itm_sbrnd_cd = 9903 then '5FOR'

					when categorycombo = 391 and collection like '%DREAM ANGELS%' then 'CLEAN'
					when categorycombo = 391 and collection like '%DARK ROMANCE%' then 'CLEAN'
					when categorycombo = 391 and collection like '%BBV NONCOLEC%' then 'CLEAN'
					when categorycombo = 391 and collection like '%MDRN LINGRE%' then 'CLEAN'
					when categorycombo = 391 and collection like '%VS COLLECT%' then 'CLEAN'

					when categorycombo = 391 then 'OTHER_PTY' else 'OTHER_CTGY' end as PTY_COMBO

			FROM cdmpdataview.MAPR_ORDER_LINE_SUMMARY AS h

			join (	select distinct ord_id from cdmpdataview.mapr_order_line_summary as a1
					join sasptmp.merchxref_digital as a2
					on a1.itm_nbr = a2.itm_sku_num

					WHERE a1.rtn_rsn_cd NOT IN  ('DC Oversold' ,'CCC SS (Short Ship) Return','CCC SS (Short Ship) Exchange')
					AND a1.ord_cre_dt between ${start_dt} and ${end_dt}
					AND a1.ORD_STAT_CD IN ('OD','CD')
					AND a1.IS_MDSE_IND=1
					AND a1.grs_dmnd_rtl_amt >= 0
					AND a1.grs_dmnd_unt_nbr > 0
					and a2.brandcombo = ${vsl_combo}
				 ) as i
			on h.ord_id = i.ord_id

			join sasptmp.MerchXRef_Digital AS x
			ON h.ITM_NBR = x.ITM_SKU_NUM

			WHERE h.rtn_rsn_cd NOT IN  ('DC Oversold' ,'CCC SS (Short Ship) Return','CCC SS (Short Ship) Exchange')
			AND h.ord_cre_dt between ${start_dt} and ${end_dt}
			AND h.ORD_STAT_CD IN ('OD','CD')
			AND h.IS_MDSE_IND=1
			AND h.grs_dmnd_rtl_amt >= 0
			AND h.grs_dmnd_unt_nbr > 0

		) WITH DATA AND STATS primary index(SHPG_TRXN_ID, STYL_CD, CHC_CD)
	  ) by tera;
execute(commit work) by tera;
execute(grant all on sasptmp.${t_name}_DRIVER_FILE_TY_D to ${users}) by tera;


drop table sasptmp.${t_name}_DRIVER_FILE_TY;

execute(CREATE TABLE sasptmp.${t_name}_DRIVER_FILE_TY, no fallback as
		(
			SELECT * from sasptmp.${t_name}_DRIVER_FILE_TY_S
			UNION ALL
			SELECT * from sasptmp.${t_name}_DRIVER_FILE_TY_D

		) WITH DATA AND STATS primary index(shpg_trxn_id, styl_cd, chc_cd)
	  ) by tera;
execute(commit work) by tera;
execute(grant all on sasptmp.${t_name}_DRIVER_FILE_TY to ${users}) by tera;

