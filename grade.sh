#Since for windows there are two separate CPATHs for compiling and running JUnit tests.
CPATH='.:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar'

rm -rf student-submission
rm -rf grading-area

mkdir grading-area

git clone $1 student-submission
echo 'Finished cloning'

# Checks if ListExamples.java exists.
# If it doesn't send an error.
if [ ! -e "student-submission/ListExamples.java" ]; then 
    echo "Error: No ListExamples.java file found."
    exit 1
fi

# Copies ListExamples.java, TestListExamples.java, and all JUnit files in lib to grading-area
cp student-submission/ListExamples.java grading-area/
cp TestListExamples.java grading-area/
cp -r lib grading-area/

# Compiles JUnit Tests and sees if there is an error code
# If so, send an error.
cd grading-area
javac -cp $CPATH *.java

if [ $? -ne 0 ]; then
    echo "Error: Compilation error."
    exit 1
fi

# Runs JUnit Tests and redirects all output into test-results.txt
java -cp $CPATH org.junit.runner.JUnitCore TestListExamples > test-results.txt 2>&1

# Checks if there is any FAILURES!!! from the JUnit test.
# If so, tells the user that tests failed
if grep "FAILURES!!!" test-results.txt; then
    echo "Tests failed. See test-results.txt for details."
else
    echo "All tests passed."
fi