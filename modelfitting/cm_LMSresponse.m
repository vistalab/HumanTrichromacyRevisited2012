function LMSrespToSPDs = cm_LMSresponse(LMSfunction, StimSPD, backgroundSPD)

LMSrespToSPDs = (LMSfunction' * StimSPD) ./  ((LMSfunction' * backgroundSPD) * ones(1,size(StimSPD, 2))) * 100;

end