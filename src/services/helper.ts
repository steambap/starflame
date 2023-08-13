export function xor<T>(arr: T[], item: T) {
  return arr.includes(item) ? arr.filter((i) => i !== item) : [...arr, item];
}

export function groupBy<T>(
  array: T[],
  predicate: (value: T, index: number, array: T[]) => string
) {
  return array.reduce((acc, value, index, array) => {
    (acc[predicate(value, index, array)] ||= []).push(value);
    return acc;
  }, {} as { [key: string]: T[] });
}
