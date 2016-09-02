% Builds the grid structure
function [GridObj] = GridObjMakerRD(Nx,Lbox,Lr,dx,x,dt)

GridObj = struct('Nx',Nx, 'Lbox',Lbox,'Lr',Lr,...
    'dx', dx, 'x', x,'VNcoef', dt/dx^2);

end
