export function formatDate(dateStr) {
    const [year, month, day] = dateStr.split("-")
    return parseInt(month).toString() + "/" + day
}

export function withK(number) {
    if (number >= 1000) {
        return (number/1000).toString() + "k"
    } else {
        return number
    }
}