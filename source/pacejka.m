function mu = pacejka(Coeff, sigma)
    B = Coeff(1);
    C = Coeff(2);
    D = Coeff(3);
    E = Coeff(4);
    deltaX = Coeff(5);
    deltaY = Coeff(6);

    mu = D*sin(C*atan(B*(sigma - deltaX) - E*(B*(sigma - deltaX) - atan(B*(sigma - deltaX))))) + deltaY;
end