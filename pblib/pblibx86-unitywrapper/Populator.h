#import "PlaybasisResponsesWrapper.h"
#import "PBResponses.h"

@interface Populator : NSObject

+ (void) populatePlayerBasic:(playerBasic*)outData from:(PBPlayerBasic*)pbData;
+ (void) populatePlayerPublic:(playerPublic*)outData from:(PBPlayerPublic_Response*)pbData;
+ (void) populatePlayer:(player*)outData from:(PBPlayer_Response*)pbData;
+ (void) populatePointArray:(_array<point>*)outData from:(NSArray*)pbArray;
+ (void) populateQuizArray:(_array<quizBasic>*)outData from:(NSArray*)pbArray;
+ (void) populateQuizBasic:(quizBasic*)outData from:(PBQuizBasic*)pbData;
+ (void) populateQuiz:(quiz*)outData from:(PBQuiz*)pbData;
+ (void) populateGrade:(grade*)outData from:(PBGrade*)pbData;
+ (void) populateGradeArray:(_array<grade>*)outData from:(NSArray*)pbArray;
+ (void) populateGradeRewards:(gradeRewards*)outData from:(PBGradeRewards*)pbData;
+ (void) populateGradeRewardCustom:(gradeRewardCustom*)outData from:(PBGradeRewardCustom*)pbData;
+ (void) populateGradeRewardCustomArray:(_array<gradeRewardCustom>*)outData from:(NSArray*)pbArray;
+ (void) populateQuizDone:(quizDone*)outData from:(PBQuizDone*)pbData;
+ (void) populateQuizDoneArray:(_array<quizDone>*)outData from:(NSArray*)pbArray;
+ (void) populateGradeDone:(gradeDone*)outData from:(PBGradeDone*)pbData;
+ (void) populateGradeDoneReward:(gradeDoneReward*)outData from:(PBGradeDoneReward*)pbData;
+ (void) populateGradeDoneRewardArray:(_array<gradeDoneReward>*)outData from:(NSArray*)pbArray;
+ (void) populateQuizPending:(quizPending*)outData from:(PBQuizPending*)pbData;
+ (void) populateQuizPendingArray:(_array<quizPending>*)outData from:(NSArray*)pbArray;
+ (void) populateQuizPendingGrade:(quizPendingGrade*)outData from:(PBQuizPendingGrade*)pbData;
+ (void) populateQuizPendingGradeReward:(quizPendingGradeReward*)outData from:(PBQuizPendingGradeReward*)pbData;
+ (void) populateQuizPendingGradeRewardArray:(_array<quizPendingGradeReward>*)outData from:(NSArray*)pbArray;
+ (void) populateQuestion:(question*)outData from:(PBQuestion*)pbData;
+ (void) populateQuestionOption:(questionOption*)outData from:(PBQuestionOption*)pbData;
+ (void) populateQuestionOptionArray:(_array<questionOption>*)outData from:(NSArray*)pbArray;
+ (void) populateQuestionAnswered:(questionAnswered*)outData from:(PBQuestionAnswered*)pbData;
+ (void) populateQuestionAnsweredOption:(questionAnsweredOption*)outData from:(PBQuestionAnsweredOption*)pbData;
+ (void) populateQuestionAnsweredOptionArray:(_array<questionAnsweredOption>*)outData from:(NSArray*)pbArray;
+ (void) populateQuestionAnsweredGradeDone:(questionAnsweredGradeDone*)outData from:(PBQuestionAnsweredGradeDone*)pbData;

@end