/**
 * ## Tim Sort
 * Hybrid sorting algorithm derived from merge sort and insertion sort.
 *
 * **Sorts in place**.
 * You might not need to get the return value.
 *
 * @see
 * https://en.wikipedia.org/wiki/Timsort
 *
 * @param {list} to_sort - The list to sort.
 *
 * @param {proc} cmp - The comparison proc to use. Default: Numeric ascending.
 *
 * @param {boolean} associative - Whether the list is associative. Default: FALSE.
 *
 * @param {int} fromIndex - The index to start sorting from. Default: 1.
 *
 * @param {int} toIndex - The index to stop sorting at. Default: 0.
 */
/proc/sortTim(list/to_sort, cmp = GLOBAL_PROC_REF(cmp_numeric_asc), associative = FALSE, fromIndex = 1, toIndex = 0) as /list
	CREATE_SORT_INSTANCE(to_sort, cmp, associative, fromIndex, toIndex)

	sorter.timSort(fromIndex, toIndex)

	return to_sort
