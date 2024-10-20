
*Especificamos nuestra carpeta de trabajo
cd "D:\ENAPRES"

*Bajar los archivos en Stata de la encuesta del modulo 1731 del anio 2022 y 2021

*Pasar los archivos de Spss a Stata
*Anio 2022
import spss  CAP_600_URBANO_7.sav, clear
foreach v of var * {
	rename `v' `=lower("`v'")'
}
save          2022_CAP_600_URBANO_7.dta, replace

*Anio 2021
import spss  CAP_600_URBANO_7.sav, clear
foreach v of var * {
	rename `v' `=lower("`v'")'
}
save          2021_CAP_600_URBANO_7.dta, replace


*Unir las bases en Stata
**********************************************
use          2022_CAP_600_URBANO_7.dta, clear
append using 2021_CAP_600_URBANO_7.dta

*resfin= Resultado final de la encuesta HOGAR 1: COMPLETA 2: INCOMPLETA
*p204= ¿ES MIEMBRO DEL HOGAR? N
*p205= ¿SE ENCUENTRA AUSENTE DEL HOGAR 6 MESES O MÁS
*p206= ¿ESTA PRESENTE EN EL HOGAR 6 MESES O MÁS?
*p600_a= PERSONA N°
*p600_c= INFORMANTE N°

*convertir a variable numerica
destring anio, replace

*residentes e información directa
gen resid = (p204==1 & p205==2)|(p204==2 & p206==1)
gen direc = p600_a == p600_c
gen codperso = p600_a

*Población objetivo
keep if area==1 & (resfin==1 | resfin==2) & resid==1 & (p208_a>=15 & p208_a<=98) & direc==1


/* P601_1 EN LOS ÚLTIMOS 12 MESES ¿UD. HA SIDO VÍCTIMA DE: Robo de vehiculo automotor (auto, camioneta, etc.)? 
P601_2 EN LOS ÚLTIMOS 12 MESES ¿UD. HA SIDO VÍCTIMA DE: Intento de robo de vehiculo automotor (auto, camioneta, etc.)?
P601_3A EN LOS ÚLTIMOS 12 MESES ¿UD. HA SIDO VÍCTIMA DE: Robo de autopartes del vehículo automotor (faros, llantas, aros, etc.)?
P601_3B EN LOS ÚLTIMOS 12 MESES ¿UD. HA SIDO VÍCTIMA DE: Intento de robo de autopartes del vehículo automotor (faros, llantas, aros, etc.)?
P601_4A EN LOS ÚLTIMOS 12 MESES ¿UD. HA SIDO VÍCTIMA DE: Robo de motocicleta/ mototaxi?
P601_4B EN LOS ÚLTIMOS 12 MESES ¿UD. HA SIDO VÍCTIMA DE: Intento de robo de motocicleta/ mototaxi?
P601_5A EN LOS ÚLTIMOS 12 MESES ¿UD. HA SIDO VÍCTIMA DE: Robo de bicicleta?
P601_5B EN LOS ÚLTIMOS 12 MESES ¿UD. HA SIDO VÍCTIMA DE: Intento de robo de bicicleta?
P601_6A EN LOS ÚLTIMOS 12 MESES ¿UD. HA SIDO VÍCTIMA DE: Robo de dinero, cartera, celular, etc.?
P601_6B EN LOS ÚLTIMOS 12 MESES ¿UD. HA SIDO VÍCTIMA DE: Intento de robo de dinero, cartera, celular, etc.?
P601_7 EN LOS ÚLTIMOS 12 MESES ¿UD. HA SIDO VÍCTIMA DE: Amenazas e intimidaciones? N 11
P601_8 EN LOS ÚLTIMOS 12 MESES ¿UD. HA SIDO VÍCTIMA DE:Maltrato físico y/o psicológico de algún miembro de su hogar?
P601_9 EN LOS ÚLTIMOS 12 MESES ¿UD. HA SIDO VÍCTIMA DE:Ofensas sexuales (acoso, abuso, violación, etc.)?
P601_10 EN LOS ÚLTIMOS 12 MESES ¿UD. HA SIDO VÍCTIMA DE:Secuestro?
P601_11 EN LOS ÚLTIMOS 12 MESES ¿UD. HA SIDO VÍCTIMA DE: Intento de secuestro?
P601_12 EN LOS ÚLTIMOS 12 MESES ¿UD. HA SIDO VÍCTIMA DE: Extorsion?
P601_12A EN LOS ÚLTIMOS 12 MESES ¿UD. HA SIDO VÍCTIMA DE: Intento de extorsion?
P601_13 EN LOS ÚLTIMOS 12 MESES ¿UD. HA SIDO VÍCTIMA DE: Estafa?
P601_14 EN LOS ÚLTIMOS 12 MESES ¿UD. HA SIDO VÍCTIMA DE: Robo del negocio?
P601_15 EN LOS ÚLTIMOS 12 MESES ¿UD. HA SIDO VÍCTIMA DE: Otro?
P601_15_O EN LOS ÚLTIMOS 12 MESES ¿USTED HA SIDO VÍCTIMA DE Otro_Especifique
*/

*Hechos delictivos en personas de 15 anios o mas en areas urbanas (PNDIS)
gen inseguridad = (p601_1==1 | p601_2==1 | p601_3a==1 | p601_3b==1 | p601_4a==1 | p601_4b==1 | p601_5a==1 | p601_5b==1 | p601_6a==1 | p601_6b==1 | p601_7==1 | p601_8==1 | p601_9==1 | p601_10==1 | p601_11==1 | p601_12==1 | p601_13==1 | p601_14==1 | p601_15==1)
recode inseguridad(1=100)


*ambitos
gen ubigeo = ccdd + ccpp + ccdi
gen dpto= real(substr(ubigeo,1,2))
replace dpto=15 if (dpto==7)
label define dpto 1"Amazonas" 2"Ancash" 3"Apurimac" 4"Arequipa" 5"Ayacucho" 6"Cajamarca" 8"Cusco" 9"Huancavelica" 10"Huanuco" 11"Ica" /*
*/12"Junin" 13"La Libertad" 14"Lambayeque" 15"Lima" 16"Loreto" 17"Madre de Dios" 18"Moquegua" 19"Pasco" 20"Piura" 21"Puno" 22"San Martin" /*
*/23"Tacna" 24"Tumbes" 25"Ucayali" 
lab val dpto dpto 

gen          limareg=1 if(substr(ubigeo,1,4))=="1501"
replace      limareg=2 if(substr(ubigeo,1,2))=="07"
replace      limareg=3 if((substr(ubigeo,1,4))>="1502" & (substr(ubigeo,1,4))<"1599")
label define limareg 1 "ProvLima" 2 "ProvCallao" 3 "RegLima"
label val limareg limareg



***** SALIDAS ******************************************************************
table dpto    anio [aw = factor], stat(mean inseguridad) nototal nformat(%3.1f)
table limareg anio [aw = factor], stat(mean inseguridad) nototal nformat(%3.1f)
table p207    anio [aw = factor], stat(mean inseguridad) nformat(%3.1f)

*With CI
svyset [pweight = factor], psu(conglomerado)strata(estrato)
svy:mean inseguridad, over(anio dpto) cformat(%3.1f)
svy:mean inseguridad, over(anio limareg) cformat(%3.1f)
svy:mean inseguridad, over(anio p207) cformat(%3.1f)

