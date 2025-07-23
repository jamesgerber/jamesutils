function prepmanycsvs(dirpath);
% prepmanycsvs - run utilities on a directory of csvs


wd=pwd

try

    cd(dirpath);

    a=dir('*.csv');

    for j=1:numel(a)
        csvname=a(j).name;
        txtname=strrep(a(j).name,'.csv','.txt');
        txtnqname=strrep(a(j).name,'.csv','nq.txt');
        csv2tabdelimited(csvname,txtname);

        disp(['  sed  ''s/"//g'' "' txtname '" > "' txtnqname '"']);
        unix(['  sed  ''s/"//g'' "' txtname '" > "' txtnqname '"']);

    end
    cd(wd)
catch
    cd(wd)
end

