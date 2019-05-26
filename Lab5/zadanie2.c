# include <stdio.h>

extern short getStatus();
extern short getControl();
extern void setControl(int mask, int set);
extern void checkError();

int main(){

    int option=1;
    int exception=1;
    int set=0;
    do
    {
        printf("Select option:\n");
        printf("1 - show Status Word\n");
        printf("2 - show Control Word:\n");
        printf("3 - change exception flag:\n");
        printf("4 - test mask\n");
        printf("0 - close program\n");
        scanf("%d", &option);
 
        switch(option)
        {
        case 1:
            printf("\n Current Status Word: %hd \n\n", getStatus());
            break;
        case 2:
            printf("\n Current Control Word: %hd \n\n", getControl());
            break;
        case 3:
            printf("Select exception mask to change: \n");
            printf("1 - Invalid operation exception mask\n");
            printf("2 - Denormal operand exception mask\n");
            printf("3 - Zero divide exception mask\n");            
            printf("4 - Overflow exception mask\n");
            printf("5 - Underflow exception mask\n");
            printf("6 - Precision exception mask\n");
            scanf("%d",&exception);
            switch(exception){
                case 1:
                    printf("Invalid operation exception mask\n");
                    printf("1 - Unset\n");
                    printf("2 - Set\n");
                    scanf("%d", &set);
                    if(set==1){
                        setControl(0,0);
                    }
                    else
                    {
                        setControl(0,1);
                    }
                    printf("\n Current Control Word: %hd \n\n\n", getControl());
                    break;
                case 2:
                    printf("Denormal operand exception mask\n");
                    printf("1 - Unset\n");
                    printf("2 - Set\n");
                    scanf("%d", &set);
                    if(set==1){
                        setControl(1,0);
                    }
                    else
                    {
                        setControl(1,1);
                    }
                    printf("\n Current Control Word: %hd \n\n\n", getControl());
                    break;
                case 3:
                    printf("Zero divide exception mask\n");
                    printf("1 - Unset\n");
                    printf("2 - Set\n");
                    scanf("%d", &set);
                    if(set==1){
                        setControl(2,0);
                    }
                    else
                    {
                        setControl(2,1);
                    }
                    printf("\n Current Control Word: %hd \n\n\n", getControl());
                    break;
                case 4:
                    printf("Overflow exception mask\n");
                    printf("1 - Unset\n");
                    printf("2 - Set\n");
                    scanf("%d", &set);
                    if(set==1){
                        setControl(3,0);
                    }
                    else
                    {
                        setControl(3,1);
                    }
                    printf("\n Current Control Word: %hd \n\n\n", getControl());
                    break;
                case 5:
                    printf("Underflow exception mask\n");
                    printf("1 - Unset\n");
                    printf("2 - Set\n");
                    scanf("%d", &set);
                    if(set==1){
                        setControl(4,0);
                    }
                    else
                    {
                        setControl(4,1);
                    }
                    printf("\n Current Control Word: %hd \n\n\n", getControl());
                    break;
                case 6:
                    printf("Precision exception mask\n");
                    printf("1 - Unset\n");
                    printf("2 - Set\n");
                    scanf("%d", &set);
                    if(set==1){
                        setControl(5,0);
                    }
                    else
                    {
                        setControl(5,1);
                    }
                    printf("\n Current Control Word: %hd \n\n\n", getControl());
                    break;
            }
            break;
        case 4:
            checkError();
            break;
        }

    } while(option!=0);

    return 0;
}
