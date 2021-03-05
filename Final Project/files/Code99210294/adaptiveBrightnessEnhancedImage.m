%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% adaptiveBrightnessEnhancedImage %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
    This function enhances image using adaptive brightness algorithem proposed by paper
    input(s) : {Is : saturation component of the original image ,
                Iv : brightness component of the original image ,
                Iv_g : reflection component calculated by gaussian multi scale function,
                alpha : parameter}

    output(s) : {I_prime_v : enhanced image}                                                                              
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function I_prime_v = adaptiveBrightnessEnhancedImage(Is , Iv, Iv_g, alpha)
    k = alpha * sum(sum(Is)) / (height(Is) * width(Is));
    I_prime_v = Iv .* (255 + k) ./ (max(Iv , Iv_g) + k);
end