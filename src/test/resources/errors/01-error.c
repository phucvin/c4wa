extern int pointer_assignment () {
    float f_ptr[3];
    double * d_ptr;

    d_ptr = f_ptr;

    f_ptr = 1;

    return 0;
}