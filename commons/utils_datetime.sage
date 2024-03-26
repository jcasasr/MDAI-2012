#########################
# DATE & TIME FUNCTIONS #
#########################

# From seconds to time
# @seconds: float
# @return: string
def timestamp_to_string(time):
    secs = 0;
    mins = 0;
    hours = 0;
    days = 0;
    
    # transform to integer
    time = round(time, 0);
    
    # seconds
    secs = time%60;
    # minutes
    time = floor(time/60);
    mins = time%60;
    # hours
    time = floor(time/60);
    hours = time%24;
    # days
    time = floor(time/24);
    days = time;
    
    return str(days)+" days, "+str(hours)+":"+str(mins)+":"+str(secs);
