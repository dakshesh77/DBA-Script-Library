

select '('''+(select replace('5300539816
5300637792
5300625490
5300561610
5300576288
5300651592
5300588113
5300633784
5300611561
5300538015
5300488334
5300484501
5300549452
5300568865
5300608030
5300575645
5300484337
5300478800
5300545066
5300541863
5300556852
5300481337
5300501751
5300500089
5300502481
5300574890
5300613857
5300508536
5300515685
5300527569
5300653000
5300555904
5300463868
5300465171
5300537444
5300536249
5300535477
5300485898', char(13)+char(10), ''', '''))+''')'


/*


select s.*
from Student s
where s.Number in (select '('''+(select replace('5300539816
5300637792
5300625490
5300561610
5300576288
5300651592
5300588113
5300633784
5300611561
5300538015
5300488334
5300484501
5300549452
5300568865
5300608030
5300575645
5300484337
5300478800
5300545066
5300541863
5300556852
5300481337
5300501751
5300500089
5300502481
5300574890
5300613857
5300508536
5300515685
5300527569
5300653000
5300555904
5300463868
5300465171
5300537444
5300536249
5300535477
5300485898', char(13)+char(10), ''', '''))+''')'
)




select top 1 Num = '('''+(select replace('5300539816
5300637792
5300625490
5300561610
5300576288
5300651592
5300588113
5300633784
5300611561
5300538015
5300488334
5300484501
5300549452
5300568865
5300608030
5300575645
5300484337
5300478800
5300545066
5300541863
5300556852
5300481337
5300501751
5300500089
5300502481
5300574890
5300613857
5300508536
5300515685
5300527569
5300653000
5300555904
5300463868
5300465171
5300537444
5300536249
5300535477
5300485898', char(13)+char(10), ''', '''))+''')'
from Student s
--where s.Number in (select replace('
--5300539816
--5300637792
--5300625490
--5300561610
--5300576288
--5300651592
--5300588113
--5300633784
--5300611561
--5300538015
--5300488334
--5300484501
--5300549452
--5300568865
--5300608030
--5300575645
--5300484337
--5300478800
--5300545066
--5300541863
--5300556852
--5300481337
--5300501751
--5300500089
--5300502481
--5300574890
--5300613857
--5300508536
--5300515685
--5300527569
--5300653000
--5300555904
--5300463868
--5300465171
--5300537444
--5300536249
--5300535477
--5300485898', char(13)+char(10), '')
--)


*/