function UpdateWaitBar( wb, itemnumber )
%UPDATEWAITBAR updates a waitbar initialized with InitializeWaitBar
%   wb is a waitbar structure from InitializeWaitBar
%   itemnumber is the current item number
    
tleft = (wb.numitems-itemnumber)*(toc(wb.t0)/itemnumber);

dleft = floor(tleft / (3600*24));    
hleft = floor( mod(tleft, 3600*24) / 3600);
mleft = floor( mod(tleft,3600) / 60);
sleft = floor( mod(tleft,60));

if(dleft>0), tmsg = sprintf('%ddays %dh %dm %ds', dleft, hleft, mleft, sleft);
elseif(hleft>0), tmsg = sprintf('%dh %dm %ds', hleft, mleft, sleft);
elseif(mleft>0), tmsg = sprintf('%dm %ds', mleft, sleft);
else tmsg = sprintf('%ds', sleft);
end

msg = sprintf('%s %d of %d (%3.2f%%)\n estimated time remaining: %s', wb.itemname, itemnumber, wb.numitems, itemnumber/wb.numitems*100, tmsg);
waitbar(itemnumber/wb.numitems, wb.h, msg);

end

