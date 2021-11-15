void printf();

struct Student { int access; char * name; };

struct Student * makeStudent(char * name, struct Student ** p_res) {
    printf("Calling makeStudent()\n");
    struct Student * res = alloc(0, 1, struct Student);
    res->name = name;
    res->access = 11;
    * p_res = res;

    return res;
}

void print_student(struct Student * student) {
    printf("Student name is %s, access = %d\n", student->name, student->access);
}

extern int main () {
    struct Student ** p_student = alloc(10, 1, struct Student *);
    makeStudent("Vasya", p_student)->access *= 2;
    struct Student * student = * p_student;
    print_student(student);

    student->access --;
    // student->name[4] ++; // causes bus error in native exe
    print_student(* p_student);
    return 0;
}
// Calling makeStudent()
// Student name is Vasya, access = 22
// Student name is Vasya, access = 21