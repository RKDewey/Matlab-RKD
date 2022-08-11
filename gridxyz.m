function [zg,xg,yg]=gridxyz(x,y,z)
% function [zg,xg,yg]=gridxyz(x,y,z|xv,yv)
% 
% Function to grid sparse data values (x,y,z) one point at a time
% 1) Initial call gridxyz(xv,yv,[]) to intialize grid using meshgrid
% 2) Subsequent calls with only single or vector x,y,z values
% 3) final call with outputs [zg,xg,yg] or [zg] for image/surf plotting.
% Makes suite of necessary variables global for all calls, until final call.
%
% global zg xmm ymm nx ny wg dx dy wx wy itot gxmm gymm gzmm
%
% RKD 04/07 (based on old (1989) Fortran code!)
global zg xmm ymm nx ny wg dx dy wx wy itot gxmm gymm gzmm
pack
if nargin==2, % initialize
    xmm=minmax(x);
    ymm=minmax(y);
    nx=length(x);
    ny=length(y);
    zg=zeros(length(y),length(x));
    wg=zg;
    dx=(xmm(2)-xmm(1))/(nx-1);
    dy=(ymm(2)-ymm(1))/(ny-1);
    itot=0;
    clear x y
else
    if nargout==0 & nargin==3, % then grid this point
        gxmm=minmax([gxmm x]);
        gymm=minmax([gymm y]);
        gzmm=minmax([gzmm z]);
        % first only grid values in domain
        igood=find(x>(xmm(1)-dx/2) & x<(xmm(2)+dx/2) & y>(ymm(1)-dy/2) & y<(ymm(2)+dy/2));
        itot=itot+length(igood);
        x=x(igood);y=y(igood);z=z(igood);
        % now determine linear weights
        ddx=(x-xmm(1))/dx;
        ddy=(y-ymm(1))/dy;
        ix=round(ddx)+1;
        iy=round(ddy)+1;
        i1=find(ddx>=0);
        wx(i1)=1.0 - (ddx(i1)-(ix(i1)-1));
        i2=find(ddx<0);
        wx(i2)=abs(ddx(i2)-(ix(i2)-1));
        i1=find(ddy>=0);
        wy(i1)=1.0 - (ddy(i1)-(iy(i1)-1));
        i2=find(ddx<0);
        wy(i2)=abs(ddy(i2)-(iy(i2)-1));
        wx1=1.0-wx;
        wy1=1.0-wy;
        ix1=ix+1;
        iy1=iy+1;
        % now add internal weighted data to grid 
        % NOTE: matlab does indixes [rows,cols], which is [y,x]
        for i=1:length(ix),
            zg(iy(i),ix(i))=zg(iy(i),ix(i)) + (wx(i)*wy(i)*z(i));
            wg(iy(i),ix(i))=wg(iy(i),ix(i)) + (wx(i)*wy(i));
        end
        % now check border points
        i1=find(ix1<=nx & iy>0);
        if ~isempty(i1), 
            for i=1:length(i1),
                zg(iy(i1(i)),ix1(i1(i)))=zg(iy(i1(i)),ix1(i1(i)))+(wx1(i1(i))*wy(i1(i))*z(i1(i))); 
                wg(iy(i1(i)),ix1(i1(i)))=wg(iy(i1(i)),ix1(i1(i)))+(wx1(i1(i))*wy(i1(i))); 
            end
        end
        i1=find(iy1<=ny & ix>0);
        if ~isempty(i1), 
            for i=1:length(i1),
                zg(iy1(i1(i)),ix(i1(i)))=zg(iy1(i1(i)),ix(i1(i)))+(wx(i1(i))*wy1(i1(i))*z(i1(i))); 
                wg(iy1(i1(i)),ix(i1(i)))=wg(iy1(i1(i)),ix(i1(i)))+(wx(i1(i))*wy1(i1(i))); 
            end
        end
        i1=find(ix1<=nx & iy1<=ny);
        if ~isempty(i1), 
            for i=1:length(i1),
                zg(iy1(i1(i)),ix1(i1(i)))=zg(iy1(i1(i)),ix1(i1(i)))+(wx1(i1(i))*wy1(i1(i))*z(i1(i))); 
                wg(iy1(i1(i)),ix1(i1(i)))=wg(iy1(i1(i)),ix1(i1(i)))+(wx1(i1(i))*wy1(i1(i))); 
            end
        end
    elseif nargout>0, % then finished, determine final gridded data
        disp([' Total number of data values gridded: ',num2str(itot)]);
        disp([' Range of X values: ',num2str(gxmm)]);
        disp([' Range of Y values: ',num2str(gymm)]);
        disp([' Range of Z values: ',num2str(gzmm)]);
        i=find(wg>0);j=find(wg==0);
        zg(i)=zg(i)./wg(i);
        if ~isempty(j), zg(j)=NaN; end
        clear wg;pack
        if nargout>1,
           [xg,yg]=meshgrid([xmm(1):dx:xmm(2)],[ymm(1):dy:ymm(2)]);
        end
% Clean up working variables
% global zg xmm ymm nx ny wg dx dy wx wy itot gxmm gymm gzmm
        save tempxyz gxmm gymm gzmm
        clear xmm ymm nx ny dx dy wx wy itot gxmm gymm gzmm
        pack
    end
end
% fini
