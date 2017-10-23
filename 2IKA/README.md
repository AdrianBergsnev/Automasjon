Opprette AD brukere for 2IKA Hønefoss


Dette skriptet er hardkodet for IKT-Klassen på Hønefoss VGS. Dette skriptet oppretter brukere, og setter dem i Elevgruppe
Det eneste man trenger å gjøre er å passe på at "CSV" pathen stemmer med din egen .csv fil.
Eksempel på hvordan hvordan en bruker ser ut på .csv filen:
Fornavn;Etternavn;Passord
Ghada;Alashqar;8EGB4MA
Skriptet tar de to første bokstavene i fornavn og to første i etternavn etterfulgt av årstallet:
(eksempel): GhAl2017
Klasselisten for IKT elever 2017-2018 ligger i Klasseliste.csv på samme repo
Output med brukernavn og passord havner i terminalen etter man har kjørt scriptet.
Brukerne må logge på en domenemaskin, for å der etter bli bedt om å endre passordet sitt.
