function xl_drawbox(pts, color, linewidth)
%XL_DRAWBOX Summary of this function goes here
%   Detailed explanation goes here
  line(pts([1 3 3 1 1]),pts([2 2 4 4 2]),'Color',color,'LineWidth',linewidth);
  return;
end