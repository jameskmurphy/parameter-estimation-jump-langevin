function wb = InitializeWaitBar( NumItems, ItemName  )
%INITIALIZEWAITBAR Summary of this function goes here
%   Detailed explanation goes here

wb.numitems = NumItems;
wb.itemname = ItemName;
msg = sprintf('%s 0 of %d (0.00%%)\nestimated time remaining: (unknown)', wb.itemname, wb.numitems);
wb.h=waitbar(0,msg);
wb.t0 = tic;
wb.cleanup = onCleanup( @()( delete( wb.h ) ) );

end

