export type DueDate = "today" | "tomorrow" | null;

export interface Todo {
  id: number;
  text: string;
  done: boolean;
  dueDate: DueDate;
}

export type View = "today" | "tomorrow" | "all";
