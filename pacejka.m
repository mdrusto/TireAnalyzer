function mu = pacejka(Coeff, sigma)
    B = Coeff(1);
    C = Coeff(2);
    D = Coeff(3);
    E = Coeff(4);
    delta_x = Coeff(5);
    delta_y = Coeff(6);

    mu = D*sin(C*atan(B*(sigma - delta_x) - E*(B*(sigma - delta_x) - atan(B*(sigma - delta_x))))) + delta_y;
end