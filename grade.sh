CPATH='.;lib/hamcrest-core-1.3.jar;lib/junit-4.13.2.jar'

rm -rf student-submission
mkdir student-submission
git clone $1 student-submission
echo 'Finished cloning'

cd student-submission

if [[ -f "ListExamples.java" ]]
then
    echo "File found"
else
    echo "File not found"
    exit 1
fi

cd ..

rm -rf mixed
mkdir mixed

cd student-submission
cp ListExamples.java ../mixed

cd ..
rm -rf student-submission


cp TestListExamples.java mixed

cp -r lib mixed

cd mixed

set +e

javac -cp $CPATH *.java 2>javac-errors.txt
if [[ $? -ne 0 ]]
then
    cat javac-errors.txt
else
    echo "Compile Success"
    java -cp $CPATH org.junit.runner.JUnitCore TestListExamples >results.txt
    # echo `grep -c "FAILURES!!!" results.txt`
    # echo `grep "FAILURES!!!" results.txt`
    

    if [[ `grep -c "FAILURES!!!" results.txt` -ne 0 ]]
    then
        echo "Grade is not 100%"
        RESULT_LINE=`grep "Tests run:" results.txt`
        COUNT=${RESULT_LINE:25:1}
        TOTAL=${RESULT_LINE:11:1}
        SCORE=$(( $TOTAL - $COUNT ))
        echo "Your Score is"
        echo "| Score: $SCORE/$TOTAL |"
    else
        echo "Grade is 100%"
    fi
fi



