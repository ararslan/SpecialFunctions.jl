function ZBESI(ZR::Float64,ZI::Float64,FNU::Float64,KODE::Integer,N::Integer,CYR::AbstractArray{Float64},CYI::AbstractArray{Float64},NZ::Integer,IERR::Integer)
    AA::Float64 = 0
    ALIM::Float64 = 0
    ARG::Float64 = 0
    ASCLE::Float64 = 0
    ATOL::Float64 = 0
    AZ::Float64 = 0
    BB::Float64 = 0
    CONEI::Float64 = 0
    CONER::Float64 = 0
    CSGNI::Float64 = 0
    CSGNR::Float64 = 0
    DIG::Float64 = 0
    ELIM::Float64 = 0
    FN::Float64 = 0
    FNUL::Float64 = 0
    I::Int32 = 0
    INU::Int32 = 0
    K::Int32 = 0
    K1::Int32 = 0
    K2::Int32 = 0
    NN::Int32 = 0
    PI::Float64 = 0
    R1M5::Float64 = 0
    RL::Float64 = 0
    RTOL::Float64 = 0
    STI::Float64 = 0
    STR::Float64 = 0
    TOL::Float64 = 0
    ZNI::Float64 = 0
    ZNR::Float64 = 0
    begin 
        PI = 3.141592653589793
    end
    begin 
        CONER = 1.0
        CONEI = 0.0
    end
    IERR = 0
    NZ = 0
    if FNU < 0.0
        IERR = 1
    end
    if KODE < 1 || KODE > 2
        IERR = 1
    end
    if N < 1
        IERR = 1
    end
    if IERR != 0
        return (NZ,IERR)
    end
    TOL = DMAX1(D1MACH4,1.0e-18)
    K1 = I1MACH15
    K2 = I1MACH16
    R1M5 = D1MACH5
    K = MIN0(IABS(K1),IABS(K2))
    ELIM = 2.303 * (DBLE(FLOAT(K)) * R1M5 - 3.0)
    K1 = I1MACH14 - 1
    AA = R1M5 * DBLE(FLOAT(K1))
    DIG = DMIN1(AA,18.0)
    AA = AA * 2.303
    ALIM = ELIM + DMAX1(-AA,-41.45)
    RL = 1.2DIG + 3.0
    FNUL = 10.0 + 6.0 * (DIG - 3.0)
    AZ = ZABS(COMPLEX(ZR,ZI))
    FN = FNU + DBLE(FLOAT(N - 1))
    AA = 0.5 / TOL
    BB = DBLE(FLOAT(I1MACH9)) * 0.5
    AA = DMIN1(AA,BB)
    if AZ > AA
        @goto line260
    end
    if FN > AA
        @goto line260
    end
    AA = DSQRT(AA)
    if AZ > AA
        IERR = 3
    end
    if FN > AA
        IERR = 3
    end
    ZNR = ZR
    ZNI = ZI
    CSGNR = CONER
    CSGNI = CONEI
    if ZR >= 0.0
        @goto line40
    end
    ZNR = -ZR
    ZNI = -ZI
    INU = INT(SNGL(FNU))
    ARG = (FNU - DBLE(FLOAT(INU))) * PI
    if ZI < 0.0
        ARG = -ARG
    end
    CSGNR = DCOS(ARG)
    CSGNI = DSIN(ARG)
    if MOD(INU,2) == 0
        @goto line40
    end
    CSGNR = -CSGNR
    CSGNI = -CSGNI
    @label line40
    (NZ,) = ZBINU(ZNR,ZNI,FNU,KODE,N,CYR,CYI,NZ,RL,FNUL,TOL,ELIM,ALIM)
    if NZ < 0
        @goto line120
    end
    if ZR >= 0.0
        return (NZ,IERR)
    end
    NN = N - NZ
    if NN == 0
        return (NZ,IERR)
    end
    RTOL = 1.0 / TOL
    ASCLE = D1MACH1 * RTOL * 1000.0
    for I = 1:NN
        AA = CYR[I]
        BB = CYI[I]
        ATOL = 1.0
        if DMAX1(DABS(AA),DABS(BB)) > ASCLE
            @goto line55
        end
        AA = AA * RTOL
        BB = BB * RTOL
        ATOL = TOL
        @label line55
        STR = AA * CSGNR - BB * CSGNI
        STI = AA * CSGNI + BB * CSGNR
        CYR[I] = STR * ATOL
        CYI[I] = STI * ATOL
        CSGNR = -CSGNR
        CSGNI = -CSGNI
        @label line50
    end
    return (NZ,IERR)
    @label line120
    if NZ == -2
        @goto line130
    end
    NZ = 0
    IERR = 2
    return (NZ,IERR)
    @label line130
    NZ = 0
    IERR = 5
    return (NZ,IERR)
    @label line260
    NZ = 0
    IERR = 4
    return (NZ,IERR)
end