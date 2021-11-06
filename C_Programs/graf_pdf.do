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
	
	use border_data_1992-2019_11_5, clear


*** FIGURE N°1 ***

	collapse (sum) total_primary total_secondary total_tertiary total_p_vehicle total_t_vehicle , by(year)

	rename total_p_vehicle vehicle_barrier_Permanent , replace 
	rename total_t_vehicle  vehicle_barrier_Temporary , replace 

	label variable vehicle_barrier_Permanent "vehicle_barrier_Permanent"
	label variable vehicle_barrier_Temporary "vehicle_barrier_Temporary"

	egen Pedestrian_Barrier = rowtotal(total_primary total_secondary total_tertiary )

	twoway line Pedestrian_Barrier  vehicle_barrier_Temporary vehicle_barrier_Permanent year, xtitle("Year")  sort lpattern( solid dot dash ) xline(2006 , lwidth(1pt) lcolor(red)) ytitle("Total Miles Constructed") title("Figure 1: Cumulative barrier construction by type") ylabel(,labsize(2.3)) xlabel(,labsize(2.3)) 

	graph export "${F}\Figura_N°1.png", replace


*** FIGURE N°2 ***

	use border_data_1992-2019_11_5, clear

	collapse (sum) total_primary total_secondary total_tertiary total_p_vehicle total_t_vehicle , by(sector_name year )

	rename total_p_vehicle vehicle_barrier_Permanent , replace 
	rename total_t_vehicle  vehicle_barrier_Temporary , replace 

	label variable vehicle_barrier_Permanent "Perm Vehicle Barrier/Total Border"
	label variable vehicle_barrier_Temporary "Temp Vehicle Barrier/Total Border"

	egen Pedestrian_Barrier = rowtotal(total_primary total_secondary total_tertiary )
	label variable Pedestrian_Barrier "Total Barrier/Total Border"

	twoway line  Pedestrian_Barrier  vehicle_barrier_Temporary vehicle_barrier_Permanent year, xtitle("Year") sort lpattern( solid dot dash ) xline(2006 , lwidth(1pt) lcolor(red)) by(sector_name) ylabel(,labsize(1.5)) xlabel(,labsize(2.6)) legend(size(*0.7)) 

	graph export "${F}\Figura_N°2.png", replace


*** FIGURE N°4 ***

	use border_data_1992-2019_11_5, clear
	keep year fence deaths apprehensions
	collapse  (sum) apprehensions deaths, by( year fence)
	sort year fence
	gen death100000 = (deaths/ apprehensions) * 100000
	twoway line deaths year if fence == 0||line deaths year if fence == 1 ,  ylabel(,labsize(2.5)) xlabel(,labsize(2.6)) legend(size(*0.7)) ytitle("Deaths")xtitle("Year")
	
	graph export "${F}\Figura_N°4_1.png", replace
	graph save Figura_N°4_1 , replace 

	twoway line death100000 year if fence == 0 ||line death100000 year if fence == 1 ,  ylabel(,labsize(2.5)) xlabel(,labsize(2.6)) legend(size(*0.7)) ytitle("Deaths x 10000 Apprehensions") xtitle("Year")
	
	graph export "${F}\Figura_N°4_2.png", replace
	graph save Figura_N°4_2 , replace 

*Unir los datos*
	graph combine "Figura_N°4_1.gph" "Figura_N°4_2.gph" 
	graph export "${F}\Figura_N°4_total.png" , replace 










