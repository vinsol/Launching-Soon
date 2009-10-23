/**
 * @author satish
 */
function countdown(container, year, month, day, hour, minute, second){

    Today = new Date();
    Todays_Year = Today.getFullYear();
    Todays_Month = Today.getMonth();
    Offset_Minutes = Today.getTimezoneOffset()
    Todays_Date = (new Date(Todays_Year, Todays_Month, Today.getDate(), Today.getHours(), Today.getMinutes(), Today.getSeconds())).getTime();
    Target_Date = (new Date(year, month - 1, day, hour, minute, second)).getTime();

    Time_Left = Math.round((Target_Date - Todays_Date) / 1000) - (Offset_Minutes * 60);

    if (Time_Left < 0) {
        Time_Left = 0;
        document.getElementById(container).parentNode.style.display = 'none'
        return false;
    }

    days = Math.floor(Time_Left / (60 * 60 * 24));
    Time_Left %= (60 * 60 * 24);
    hours = Math.floor(Time_Left / (60 * 60));
    Time_Left %= (60 * 60);
    minutes = Math.floor(Time_Left / 60);
    Time_Left %= 60;
    seconds = Time_Left;

    dps = 's';
    hps = 's';
    mps = 's';
    sps = 's';
    if (days == 1)
        dps = '';
    if (hours == 1)
        hps = '';
    if (minutes == 1)
        mps = '';
    if (seconds == 1)
        sps = '';

    container_id = container
    document.getElementById(container_id).innerHTML = days + ' day' + dps + ' ';
    document.getElementById(container_id).innerHTML += hours + ' hour' + hps + ' ';
    document.getElementById(container_id).innerHTML += minutes + ' minute' + mps + ' and ';
    document.getElementById(container_id).innerHTML += seconds + ' second' + sps;
    setTimeout('countdown(container_id, ' + year + ',' + month + ',' + day + ',' + hour + ',' + minute + ',' + second + ');', 1000);
}