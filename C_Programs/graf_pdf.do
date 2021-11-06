*** GRAPHICS CREATE****

********************************************************************************
*** PART 1: Introduction
    *--------------------------------------------------
    * 1.1 Program Setup
    *--------------------------------------------------
		clear all
		set more off
		pause on

		if "`c(username)'" == "MIGUEL" {
			global path "C:\Users\MIGUEL\Documents\GitHub\Immigration_proyect"
		}

    *--------------------------------------------------
    * 1.2 Globals
    *--------------------------------------------------  
	
		set matsize 11000

		//Change
		global dofilename "graf_pdf"

		global A "${path}\A_MicroData"
		global B "${path}\B_RawData"
		global D "${path}\D_Results"
		global E "${path}\E_Tables"
		global F "${path}\F_Figures"




********************************************************************************
*** PART 2: Cleaning border_data_1992-2019_11_5
*******************************************************************************/
	
	cd "${A}"
	
	
*** FIGURE N°1 ***

	use border_data_1992-2019_11_5, clear
	collapse (sum) total_primary total_secondary total_tertiary total_p_vehicle total_t_vehicle , by(year)

	rename total_p_vehicle vehicle_barrier_Permanent , replace 
	rename total_t_vehicle  vehicle_barrier_Temporary , replace 

	*label variable vehicle_barrier_Permanent "vehicle_barrier_Permanent"
	*label variable vehicle_barrier_Temporary "vehicle_barrier_Temporary"

	egen Pedestrian_Barrier = rowtotal(total_primary total_secondary total_tertiary )

	twoway line Pedestrian_Barrier  vehicle_barrier_Temporary vehicle_barrier_Permanent year, xtitle("Year")  sort lpattern( solid shortdash_dot dash ) xline(2006 , lpattern(solid) lcolor(red))  xlabel(,labsize(2.3)) ytitle("Total Miles Constructed") ylabel(,labsize(2.3)) legend( pos(6) lab(1 "Pedestrian_Barrier") lab(2 "vehicle_barrier_Temporary") lab(3 "vehicle_barrier_Permanent")) title("Cumulative barrier construction by type")

	graph export "${F}\Figura_N°1.png", replace
	graph export "${F}\Figura_N°1.pdf", replace


*** FIGURE N°2 ***

	use border_data_1992-2019_11_5, clear

	collapse (sum) total_primary total_secondary total_tertiary total_p_vehicle total_t_vehicle , by(sector_name year )

	rename total_p_vehicle vehicle_barrier_Permanent , replace 
	rename total_t_vehicle  vehicle_barrier_Temporary , replace 

	**label variable vehicle_barrier_Permanent "Perm Vehicle Barrier/Total Border"
	**label variable vehicle_barrier_Temporary "Temp Vehicle Barrier/Total Border"

	egen Pedestrian_Barrier = rowtotal(total_primary total_secondary total_tertiary )
	label variable Pedestrian_Barrier "Total Barrier/Total Border"

	twoway line  Pedestrian_Barrier  vehicle_barrier_Temporary vehicle_barrier_Permanent year, by(sector_name , title("County-level ratio of barrier to US-Mexico border by barrier type", span) note("")  )   ytitle("Total Miles Constructed") sort lpattern( solid shortdash_dot dash ) xtitle("Year")  ylabel(,labsize(2)) xlabel(,labsize(2.6)) legend(lab(1 "Total Barrier/Total Border") lab(2 "Temp Vehicle Barrier/Total Border") lab(3 "Perm Vehicle Barrier/Total Border") size(*0.7)) xline(2006 , lpattern(solid) lcolor(red)) 


	graph export "${F}\Figura_N°2.png", replace
	graph export "${F}\Figura_N°2.pdf", replace


*** FIGURE N°4 ***

	use border_data_1992-2019_11_5, clear
	keep year fence deaths apprehensions
	collapse  (sum) apprehensions deaths, by( year fence)
	sort year fence
	gen death100000 = (deaths/ apprehensions) * 100000
	twoway line deaths year if fence == 0||line deaths year if fence == 1 ,  ylabel(,labsize(3.5)) xlabel(,labsize(2.6)) legend(size(*0.7)) ytitle("Deaths")xtitle("Year") legend(pos(6) lab(1 " Fence 0 ") lab(2 " Fence 1 ") size(*1.5)  subtitle("FENCE") )

	
	graph export "${F}\Figura_N°4_1.png", replace
	graph export "${F}\Figura_N°4_1.pdf", replace
	graph save Figura_N°4_1 , replace 

	twoway line death100000 year if fence == 0 ||line death100000 year if fence == 1 ,  ylabel(,labsize(3.5)) xlabel(,labsize(2.6)) legend(size(*0.7)) ytitle("Deaths x 10000 Apprehensions") xtitle("Year") legend(pos(6) lab(1 " Fence 0 ") lab(2 " Fence 1 ") size(*1.5) subtitle("FENCE") ) 
	
	graph export "${F}\Figura_N°4_2.png", replace
	graph export "${F}\Figura_N°4_2.pdf", replace
	graph save Figura_N°4_2 , replace 

*UNION WITH combine*
	**graph combine "Figura_N°4_1.gph" "Figura_N°4_2.gph", title("Trends in crime rates across treatment and control counties" )
	**graph export "${F}\Figura_N°4_total.png" , replace 

*UNION WITH grc1leg*
	
	**net install grc1leg, from (http://www.stata.com/users/vwiggins) package to choose one of the two legends of the graphics
	grc1leg "Figura_N°4_1.gph" "Figura_N°4_2.gph", legendfrom("Figura_N°4_1.gph") title("Trends in crime rates across treatment and control counties" ) 
	graph export "${F}\Figura_N°4_total.png" , replace 
	graph export "${F}\Figura_N°4_total.pdf" , replace 
	
	
	/* Load stata packages and settings
* -----------------------------------
  ssc install moremata       , replace 
  ssc install mplotoffset    , replace Produce un diagrama de márgenes con cada trazado desplazado horizontalmente para permitir una visualización más clara .
  ssc install center       , replace  centra las variables para tener una media muestral cero (y, opcionalmente, varianza muestral unitaria).
  ssc install ranktest       , replace módulo de Stata para probar el rango de una matriz
  ssc install mdesc        , replace
  ssc install blindschemes   , replace módulo de Stata para proporcionar esquemas gráficos sensibles a la deficiencia de la visión del color
  ssc install xsvmat         , replace módulo Stata para convertir una matriz en variables en un conjunto de datos de salida
  ssc install spmap        , replace
  ssc install shp2dta        , replace
  net install smileplot.pkg  , replace
  ssc install ivreghdfe      , replace módulo Stata para regresiones variables instrumentales extendidas con múltiples niveles de efectos fijos
  ssc install ivreg2         , replace  módulo Stata para variables instrumentales extendidas / estimación 2SLS y GMM
  ssc install coefplot       , replace  para trazar resultados de comandos de estimación o matrices de Stata.
  ssc install egenmore       , replace 
  ssc install texdoc       , replace es un comando de Stata para crear documentos LaTeX desde dentro de Stata.
  ssc install texify       , replace módulo Stata para compilar un documento LaTeX
  ssc install groups       , replace módulo Stata para listar frecuencias de grupo
  ssc install charlist       , replace
  ssc install vmerge         , replace 
  ssc install winsor2        , replace módulo Stata para ganar datos
  ssc install palettes       , replace módulo Stata para proporcionar paletas de colores, paletas de símbolos y paletas de patrones de líneas
  ssc install fsum           , replace módulo de Stata para generar y formatear estadísticas resumidas
  ssc install splitvallabels , replace módulo Stata para dividir etiquetas de valor para etiquetado de gráficos multilínea
  ssc install reghdfe        , replace 
  ssc install ivreghdfe      , replace 
  ssc install ftools         , replace 
  ssc install matchit        , replace
  ssc install freqindex      , replace módulo Stata para generar un índice de términos a partir de una variable de cadena
  ssc install mergepoly      , replace módulo Stata para fusionar polígonos adyacentes de un shapefile
  ssc install sreshape       , replace
  
  net install grc1leg2       , from("http://digital.cgdev.org/doc/stata/MO/Misc")
 
  set more off             , permanently
  set scheme plotplainblind  , permanently
  set matsize 11000        , permanently
  set maxvar  32767        , permanently
  
  graph set window fontface "Garamond"









