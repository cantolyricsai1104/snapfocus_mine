import React from 'react';
import { TaskBlock } from '../../types';
import { formatDateToYMD, isTaskScheduledOnDate } from '../../utils/dateUtils';
import { Haptics } from '../../services/haptics';

interface MonthViewProps {
  currentDate: Date;
  onSelectDate: (date: Date) => void;
  tasks: TaskBlock[];
}

export const MonthView: React.FC<MonthViewProps> = ({
  currentDate,
  onSelectDate,
  tasks,
}) => {
  const year = currentDate.getFullYear();
  const month = currentDate.getMonth();

  const todayStr = formatDateToYMD(new Date());
  const selectedStr = formatDateToYMD(currentDate);

  // Month grid calculations (Monday as first day of week)
  const firstDayOfMonth = new Date(year, month, 1);
  const daysInMonth = new Date(year, month + 1, 0).getDate();

  // Day of week for 1st of month: 0 is Sun, convert to 0=Mon, 6=Sun
  const startDayOfWeek = (firstDayOfMonth.getDay() + 6) % 7;

  // Previous month padding days
  const prevMonthDays = new Date(year, month, 0).getDate();
  const prevDays: { day: number; dateStr: string; isCurrentMonth: boolean; date: Date }[] = [];
  for (let i = startDayOfWeek - 1; i >= 0; i--) {
    const d = new Date(year, month - 1, prevMonthDays - i);
    prevDays.push({
      day: prevMonthDays - i,
      dateStr: formatDateToYMD(d),
      isCurrentMonth: false,
      date: d,
    });
  }

  // Current month days
  const currentMonthDays: { day: number; dateStr: string; isCurrentMonth: boolean; date: Date }[] = [];
  for (let i = 1; i <= daysInMonth; i++) {
    const d = new Date(year, month, i);
    currentMonthDays.push({
      day: i,
      dateStr: formatDateToYMD(d),
      isCurrentMonth: true,
      date: d,
    });
  }

  // Next month padding days to complete grid
  const totalRendered = prevDays.length + currentMonthDays.length;
  const nextDaysCount = (7 - (totalRendered % 7)) % 7;
  const nextDays: { day: number; dateStr: string; isCurrentMonth: boolean; date: Date }[] = [];
  for (let i = 1; i <= nextDaysCount; i++) {
    const d = new Date(year, month + 1, i);
    nextDays.push({
      day: i,
      dateStr: formatDateToYMD(d),
      isCurrentMonth: false,
      date: d,
    });
  }

  const allCalendarDays = [...prevDays, ...currentMonthDays, ...nextDays];
  const weekDayHeaders = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  return (
    <div className="flex-1 flex flex-col h-full bg-[#0E0E11] text-white p-3 overflow-y-auto">
      {/* Weekday Labels */}
      <div className="grid grid-cols-7 gap-1.5 mb-1.5 text-center">
        {weekDayHeaders.map((dayName) => (
          <div
            key={dayName}
            className="text-[11px] font-bold uppercase tracking-wider text-neutral-400 py-1"
          >
            {dayName}
          </div>
        ))}
      </div>

      {/* Calendar Grid */}
      <div className="grid grid-cols-7 gap-1.5 flex-1 auto-rows-fr">
        {allCalendarDays.map((item, idx) => {
          const isToday = item.dateStr === todayStr;
          const isSelected = item.dateStr === selectedStr;
          const dayTasks = tasks.filter((t) => isTaskScheduledOnDate(t, item.dateStr));
          const hasTasks = dayTasks.length > 0;

          return (
            <div
              key={`${item.dateStr}-${idx}`}
              onClick={() => {
                onSelectDate(item.date);
                Haptics.selectionAsync();
              }}
              className={`min-h-[85px] p-1.5 rounded-2xl border transition-all cursor-pointer flex flex-col justify-between ${
                isSelected
                  ? 'border-[#FF6B00] bg-[#1F1612] shadow-[0_0_12px_rgba(255,107,0,0.2)]'
                  : item.isCurrentMonth
                  ? 'bg-[#15151A] hover:bg-[#1A1A22] border-white/[0.08]'
                  : 'bg-[#111114]/40 hover:bg-[#16161A] border-white/[0.03] opacity-40'
              }`}
            >
              {/* Day Number Header */}
              <div className="flex items-center justify-between">
                <span
                  className={`w-6 h-6 flex items-center justify-center rounded-full text-xs font-mono font-bold ${
                    isToday
                      ? 'bg-[#FF6B00] text-black shadow-sm'
                      : isSelected
                      ? 'text-[#FF6B00]'
                      : item.isCurrentMonth
                      ? 'text-neutral-200'
                      : 'text-neutral-500'
                  }`}
                >
                  {item.day}
                </span>

                {hasTasks && (
                  <span className="text-[10px] font-mono font-semibold text-neutral-400 px-1 rounded bg-white/5">
                    {dayTasks.length}
                  </span>
                )}
              </div>

              {/* Task Preview Chips */}
              <div className="mt-1 space-y-1 overflow-hidden flex-1 flex flex-col justify-end">
                {hasTasks ? (
                  <>
                    {dayTasks.slice(0, 2).map((t) => (
                      <div
                        key={t.id}
                        className={`text-[9px] font-semibold truncate px-1 py-0.5 rounded leading-tight ${
                          t.type === 'focus'
                            ? 'bg-[#FF6B00]/20 text-[#FF8533] border border-[#FF6B00]/30'
                            : 'bg-purple-500/20 text-purple-300 border border-purple-500/30'
                        }`}
                        title={`${t.scheduledTime || ''} ${t.title}`}
                      >
                        <span className="font-mono mr-0.5">{t.scheduledTime}</span>
                        <span>{t.title}</span>
                      </div>
                    ))}
                    {dayTasks.length > 2 && (
                      <span className="text-[8px] text-neutral-400 font-mono block text-right">
                        +{dayTasks.length - 2} more
                      </span>
                    )}
                  </>
                ) : (
                  <div className="text-[10px] text-neutral-600 font-mono italic opacity-0 hover:opacity-60 transition-opacity">
                    Blank
                  </div>
                )}
              </div>
            </div>
          );
        })}
      </div>
    </div>
  );
};
