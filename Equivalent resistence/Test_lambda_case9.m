%Test for 9 nodes
%It is based on case9 where eliminate the range of voltage 
%And it only has one generator (generator bus 1)
%The other part are the same 


Exact_5 = Test_exact_lambda(case9,5)
Predict_5 = Predict_lambda(case9,5)
Accuracy_5 = abs(Exact_5 - Predict_5) / Exact_5

Exact_7 = Test_exact_lambda(case9,7)
Predict_7 = Predict_lambda(case9,7)
Accuracy_7 = abs(Exact_7 - Predict_7) / Exact_7


Exact_9 = Test_exact_lambda(case9,9)
Predict_9 = Predict_lambda(case9,9)
Accuracy_9 = abs(Exact_9 - Predict_9) / Exact_9
